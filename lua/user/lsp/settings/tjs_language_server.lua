-- tjs language server

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local lspconfig = require("lspconfig")

local custom_attach = function(client)
end

configs.tjs_language_server = {
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
            ["code"] = "console.time($$)"
          },
          {
            ["snippetKey"] = "jsons",
            ["code"] = "JSON.stringify($$)"
          },
          {
            ["snippetKey"] = "jsonp",
            ["code"] = "JSON.parse($$)"
          },
          {
            ["snippetKey"] = "log",
            ["code"] = "console.log(`$$: `, $$)"
          },
          {
            ["snippetKey"] = "error",
            ["code"] = "console.error(`$$: `, $$)"
          },
          {
            ["snippetKey"] = "warn",
            ["code"] = "console.warn(`$$: `, $$)",
          },
          {
            ["snippetKey"] = "req",
            ["code"] = "require($$)",
          }
        }
      }
    }
  },
}


lspconfig.tjs_language_server.setup {
  on_attach = custom_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- tjs-language-server end
