vim.api.nvim_create_user_command('RustFlyCheck', function()
  local res = vim.lsp.util.make_text_document_params()
  vim.lsp.buf_notify(0, "rust-analyzer/runFlycheck", { textDocument = res })
end, {
  ["bang"] = true
})
