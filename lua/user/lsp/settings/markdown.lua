-- tjs language server

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local lspconfig = require("lspconfig")


configs.markdown = {
  default_config = {
    cmd = { 'vscode-markdown-language-server', '--stdio' },
    filetypes = {
      'markdown'
    },
    -- root_dir = function(fname)
    --   util.find_git_ancestor(fname)
    -- end,
    single_file_support = true,
    settings = {
    },
    initOptions = {
      ['markdownFileExtensions'] = {
        "md",
        "markdown"
      }
    }
  },
}


lspconfig.markdown.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- tjs-language-server end
