-- nvim-treesitter `main` branch: it only installs parsers/queries; highlighting,
-- folding and indentation are enabled per buffer below via Neovim's own APIs.
local status_ok, ts = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

ts.install({ "typescript", "rust", "javascript", "python" })

local highlight_disabled = { html = true }
local indent_disabled = { python = true, css = true }
local max_filesize = 1024 * 1024 -- 1 MB

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang or highlight_disabled[lang] or not vim.treesitter.language.add(lang) then
      return
    end
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    vim.treesitter.start(buf, lang)
    if not indent_disabled[lang] and vim.treesitter.query.get(lang, "indents") then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt["foldenable"] = false
vim.opt["foldlevel"] = 99

-- Neovim 0.12's treesitter folds cache state per buffer. A buffer with no
-- parser that is wiped inside another autocmd (codediff's diff buffers) skips
-- BufUnload, so it stays cached. A global 'foldminlines' change (codediff's
-- compact mode sets it with vim.wo[win]) refreshes every cached buffer and
-- fails on a wiped one with "Invalid buffer id". Wrap Neovim's handler so it
-- drops unloaded buffers first. If Neovim's internals change, this does
-- nothing. Remove once neovim/neovim#42301 (issue #40290) is released.
do
  require("vim.treesitter._fold") -- defines the handler
  for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "OptionSet", pattern = "foldminlines" })) do
    if au.desc == "Refresh treesitter folds" and type(au.callback) == "function" then
      local refresh, foldinfos = au.callback, nil
      for i = 1, math.huge do
        local name, value = debug.getupvalue(refresh, i)
        if name == nil or name == "foldinfos" then
          foldinfos = value
          break
        end
      end
      if type(foldinfos) == "table" then
        vim.api.nvim_del_autocmd(au.id)
        vim.api.nvim_create_autocmd("OptionSet", {
          pattern = { "foldminlines", "foldnestmax" },
          desc = au.desc,
          callback = function()
            for buf in pairs(foldinfos) do
              if not vim.api.nvim_buf_is_loaded(buf) then
                foldinfos[buf] = nil
              end
            end
            refresh()
          end,
        })
      end
    end
  end
end
