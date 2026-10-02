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
