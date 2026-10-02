-- oxc_language_server

vim.lsp.config.oxc_language_server = {
  cmd = { 'oxc_language_server' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_markers = { '.oxlintrc.json' },
  workspace_required = true,
  settings = {
    ['enable'] = true,
    ['run'] = 'onType',
    ['config'] = '.oxlintrc.json'
  },
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.enable('oxc_language_server')

-- oxc_language_server end
