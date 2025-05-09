-- just_language_server start

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local lspconfig = require("lspconfig")


configs.just_language_server = {
  default_config = {
    cmd = { 'just-lsp' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
    filetypes = {
      'just',
    },
    single_file_support = true
  },
}



lspconfig.just_language_server.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- just_language_server end
