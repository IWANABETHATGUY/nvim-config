-- oxc_language_server

local configs = require('lspconfig.configs')
local lspconfig = require("lspconfig")


configs.oxc_language_server = {
  default_config = {
    cmd = { 'oxc_language_server' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    root_dir = function(_)
      return root_pattern(".oxlintrc.json")
    end,
    single_file_support = false,
    settings = {
      ['enable'] = true,
      ['run'] = 'onType',
      ['config'] = '.oxlintrc.json'
    }
  },
}



lspconfig.oxc_language_server.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- oxc_language_server end
