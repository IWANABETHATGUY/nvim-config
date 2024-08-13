vim.api.nvim_create_user_command('RustFlyCheck', function()
  local res = vim.lsp.util.make_text_document_params()
  vim.lsp.buf_notify(0, "rust-analyzer/runFlycheck", { textDocument = res })
end, {
  ["bang"] = true
})

vim.api.nvim_create_user_command('HarpoonMarks', function()
  vim.cmd.Telescope('harpoon', 'marks')
end, {})

vim.api.nvim_create_user_command('HarpoonClearAll', function()
  vim.cmd(':lua require("harpoon.mark").clear_all()')
end, {})

vim.api.nvim_create_user_command('NeotreeReveal', function()
  vim.cmd.Neotree('reveal')
end, {})

vim.api.nvim_create_user_command('DiffviewToggle', function()
  diffview_toggle()
end, {})

vim.api.nvim_create_user_command('DiffCompareToMain', function()
  vim.cmd(':DiffviewOpen origin/main...HEAD')
end, {})


diffview_toggle = function()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    -- Current tabpage is a Diffview; close it
    vim.cmd.DiffviewClose()
  else
    -- No open Diffview exists: open a new one
    vim.cmd.DiffviewOpen()
  end
end
