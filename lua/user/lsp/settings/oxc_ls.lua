-- oxc_language_server

local util = require('lspconfig.util')
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
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
          or util.find_node_modules_ancestor(fname)
          or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      ['enable'] = true,
      ['run'] = 'onType'
    }
  },
}



lspconfig.oxc_language_server.setup {
  -- on_attach = require("user.lsp.handlers").on_attach,
  -- capabilities = require("user.lsp.handlers").capabilities,
}

-- oxc_language_server end
