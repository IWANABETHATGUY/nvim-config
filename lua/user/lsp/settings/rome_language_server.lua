-- rome-language-server

local util = require 'lspconfig.util'
local config = require('lspconfig.configs')

-- This duplicate exec is just a workaruond, if don't execute at first,
-- the nvim will stuck when you first init rome socket
local rome_cmd = { 'rome', 'lsp-proxy' }
print(rome_cmd)

config.rome_language_server = {
  default_config = {
    cmd = rome_cmd,
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
  },
}

config.rome_language_server.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}
