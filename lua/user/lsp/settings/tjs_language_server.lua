-- tjs language server

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local lspconfig = require("lspconfig")

local custom_attach = function(client) 
end

configs.tjs_langauge_server = {
  default_config = {
    cmd = { 'tjs-language-server' },
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
      ['tjs-postfix'] = {
        ["templateMapList"] = {
          {
            ["snippetKey"] = "time",
            ["functionName"] = "console.time"
          },
          {
            ["snippetKey"] = "jsons",
            ["functionName"] = "JSON.stringify"
          },
          {
            ["snippetKey"] = "jsonp",
            ["functionName"] = "JSON.parse"
          },
          {
            ["snippetKey"] = "log",
            ["functionName"] = "console.log"
          },
          {
            ["snippetKey"] = "error",
            ["functionName"] = "console.error"
          },
          {
            ["snippetKey"] = "warn",
            ["functionName"] = "console.warn",
          },
          {
            ["snippetKey"] = "req",
            ["functionName"] = "require",
          }
        }
      }
    }
  },
}


lspconfig.tjs_langauge_server.setup {
  on_attach = custom_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- tjs-language-server end
