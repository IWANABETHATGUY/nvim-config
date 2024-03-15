-- tjs language server

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local lspconfig = require("lspconfig")

local custom_attach = function(client) 
end

configs.sway_lsp = {
  default_config = {
    cmd = { 'forc-lsp' },
    filetypes = {
      "sway"
    },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
    }
  },
}


lspconfig.sway_lsp.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- tjs-language-server end
