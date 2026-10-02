-- just_language_server start

vim.lsp.config.just_language_server = {
  cmd = { 'just-lsp' },
  root_markers = { '.git' },
  filetypes = {
    'just',
  },
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.enable('just_language_server')

-- just_language_server end
