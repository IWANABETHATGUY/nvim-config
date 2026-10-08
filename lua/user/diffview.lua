-- diffview-plus.nvim (actively maintained fork of sindrets/diffview.nvim).
-- Only non-default options are listed; see `:h diffview-config` and `:h diffview.changelog`.
-- Default keymaps are used as-is (`g?` in any panel shows them).

-- focus.nvim's global disable flag as it was before entering a diffview tab;
-- nil while no diffview tab is current.
local saved_focus_disable

local function equalize(view)
  vim.schedule(function()
    if vim.api.nvim_get_current_tabpage() == view.tabpage then
      vim.cmd("wincmd =")
    end
  end)
end

require("diffview").setup({
  enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
  view = {
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_mixed",
    },
  },
  file_history_panel = {
    log_options = { -- See |diffview-config-log_options|
      git = {
        single_file = {
          diff_merges = "combined",
        },
      },
    },
  },
  hooks = {
    -- focus.nvim golden-ratio-resizes whichever window gains focus, leaving the
    -- a/b panes uneven. Per-window opt-outs miss the empty side of an added or
    -- deleted file (diffview opens it without firing diff_buf_win_enter), so
    -- turn focus.nvim off while a diffview tab is current and re-equalize
    -- after diffview lays out its windows.
    view_enter = function(view)
      if saved_focus_disable == nil then
        saved_focus_disable = vim.g.focus_disable == true
      end
      vim.g.focus_disable = true
      equalize(view)
    end,
    view_leave = function()
      if saved_focus_disable ~= nil then
        vim.g.focus_disable = saved_focus_disable
        saved_focus_disable = nil
      end
    end,
    view_post_layout = equalize,
    view_opened = function(view)
      local utils = require("user.utils");
      -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
      -- the right.
      local function post_layout()
        utils.tbl_ensure(view, "winopts.diff2.a")
        utils.tbl_ensure(view, "winopts.diff2.b")
        -- left
        view.winopts.diff2.a = utils.tbl_union_extend(view.winopts.diff2.a, {
          winhl = {
            "DiffChange:DiffAddAsDelete",
            "DiffText:DiffDeleteText",
          },
        })
        -- right
        view.winopts.diff2.b = utils.tbl_union_extend(view.winopts.diff2.b, {
          winhl = {
            "DiffChange:DiffAdd",
            "DiffText:DiffAddText",
          },
        })
      end

      view.emitter:on("post_layout", post_layout)
      post_layout()
    end,
  },
})
