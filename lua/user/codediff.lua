-- codediff.nvim (VSCode-style diffs; replaced diffview-plus.nvim).
-- The options below keep the old diffview look and keys; everything else is a
-- default. See the plugin README, or press `g?` in a codediff tab.

local M = {}

-- Tab pages that show a codediff session.
local codediff_tabs = {}
-- focus.nvim's global disable flag and 'scrolljump' as they were before a
-- codediff tab became current; nil while no codediff tab is current.
local saved

local function equalize(tabpage)
  vim.schedule(function()
    if vim.api.nvim_get_current_tabpage() == tabpage then
      vim.cmd("wincmd =")
    end
  end)
end

-- focus.nvim golden-ratio-resizes whichever window gains focus, leaving the
-- a/b panes uneven, so turn it off while a codediff tab is current and
-- re-equalize (the explorer sets 'winfixwidth', so it keeps its width).
-- The a/b panes are not full width, so the terminal cannot scroll them and
-- Neovim repaints both panes on every scrolled line. Scrolling 5 lines at a
-- time repaints 5 times less often.
local function enter(tabpage)
  if saved == nil then
    saved = { focus_disable = vim.g.focus_disable == true, scrolljump = vim.o.scrolljump }
  end
  vim.g.focus_disable = true
  vim.o.scrolljump = 5
  equalize(tabpage)
end

local function leave()
  if saved ~= nil then
    vim.g.focus_disable = saved.focus_disable
    vim.o.scrolljump = saved.scrolljump
    saved = nil
  end
end

require("codediff").setup({
  -- The old diffview colors: red on the left, green on the right. codediff
  -- copies these groups' colors, so user/colorscheme.lua must load first.
  highlights = {
    line_insert = "DiffAdd",
    line_delete = "DiffAddAsDelete",
    char_insert = "DiffAddText",
    char_delete = "DiffDeleteText",
  },
  diff = {
    -- Fold unchanged code with 6 context lines, like diffview's diff mode.
    compact = true,
    compact_context_lines = 6,
    -- OURS left, THEIRS right, result below, like diffview's "diff3_mixed".
    conflict_ours_position = "left",
    -- Blank alignment rows: each `╱` costs 3 bytes of terminal output, and
    -- every scrolled line repaints both panes.
    filler_text = "",
  },
  explorer = {
    -- diffview's file panel showed a tree with per-file line counts.
    view_mode = "tree",
    line_stats = { enabled = true },
  },
  -- diffview's default keys, kept next to the codediff defaults.
  keymaps = {
    view = {
      next_file = { "]f", "<tab>" },
      prev_file = { "[f", "<s-tab>" },
      toggle_layout = { "t", "g<C-x>" },
    },
    explorer = {
      select = { "<CR>", "o", "l", "<2-LeftMouse>" },
      fold_close = { "zc", "h" },
    },
    conflict = {
      -- diffview's meaning: b keeps BASE, a keeps all versions.
      discard = "<leader>cb",
      discard_all = "<leader>cB",
      accept_both = "<leader>ca",
      accept_all_both = "<leader>cA",
    },
  },
})

-- diffview's `:DiffviewOpen A..B` diffs A against B, but `:CodeDiff` reads
-- A..B as one revision and git rejects it, so split it into `:CodeDiff A B`.
-- Subcommands keep their arguments: `history` takes A..B as a commit range.
-- `...` (merge base) and paths such as `../dir` are left alone.
local function split_two_dot_range(fargs)
  if vim.tbl_contains(require("codediff.commands").SUBCOMMANDS, fargs[1]) then
    return fargs
  end
  for i, arg in ipairs(fargs) do
    if arg == "--" then
      break
    end
    local base, target = arg:match("^([^.].-)%.%.([^.].*)$")
    if base and not arg:find("...", 1, true) and not vim.uv.fs_stat(arg) then
      local out = vim.list_slice(fargs, 1, i - 1)
      vim.list_extend(out, { base, target })
      return vim.list_extend(out, fargs, i + 1)
    end
  end
  return fargs
end

-- Replaces the plugin's :CodeDiff (same options), which is defined by now:
-- lazy.nvim sources codediff's plugin/ files in user.plugins.
vim.api.nvim_create_user_command("CodeDiff", function(opts)
  opts.fargs = split_two_dot_range(opts.fargs)
  require("codediff.commands").vscode_diff(opts)
end, {
  nargs = "*",
  bang = true,
  range = true,
  complete = function(arg_lead, cmd_line)
    return require("codediff.commands").complete(arg_lead, cmd_line)
  end,
  desc = "Live code review workspace for Neovim",
})

local group = vim.api.nvim_create_augroup("UserCodeDiff", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffOpen",
  callback = function(event)
    codediff_tabs[event.data.tabpage] = true
    if vim.api.nvim_get_current_tabpage() == event.data.tabpage then
      enter(event.data.tabpage)
    end
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffClose",
  callback = function(event)
    codediff_tabs[event.data.tabpage] = nil
    if vim.api.nvim_get_current_tabpage() == event.data.tabpage then
      leave()
    end
  end,
})
-- WinEnter runs before TabEnter, so focus.nvim can resize the panes before
-- `enter` turns it off; `enter` then re-equalizes them.
vim.api.nvim_create_autocmd("TabEnter", {
  group = group,
  callback = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    if codediff_tabs[tabpage] then
      enter(tabpage)
    end
  end,
})
vim.api.nvim_create_autocmd("TabLeave", {
  group = group,
  callback = function()
    if codediff_tabs[vim.api.nvim_get_current_tabpage()] then
      leave()
    end
  end,
})

function M.is_open(tabpage)
  return codediff_tabs[tabpage] == true
end

-- Closes a codediff tab like its `q` key does: codediff cleans up on
-- TabClosed, and Neovim cannot close the last tab page.
function M.close(tabpage)
  if #vim.api.nvim_list_tabpages() == 1 then
    vim.cmd("tabnew")
  end
  vim.cmd(vim.api.nvim_tabpage_get_number(tabpage) .. "tabclose")
end

return M
