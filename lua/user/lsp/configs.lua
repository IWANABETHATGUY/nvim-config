local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local lspconfig = require("lspconfig")

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')

-- tjs-language-server
-- local tjs_bin_name = 'tjs-language-server'
-- local cmd = { tjs_bin_name }
--
-- local custom_attach = function(client) print("Tjs langauge server LSP started."); end
--
-- if not configs.tjs_langauge_server then
--   configs.tjs_langauge_server = {
--     default_config = {
--       cmd = cmd,
--       filetypes = {
--         'javascript', 'javascriptreact',
--         'typescript',
--         'typescriptreact',
--       },
--       root_dir = function(fname)
--         return util.find_package_json_ancestor(fname)
--             or util.find_node_modules_ancestor(fname)
--             or util.find_git_ancestor(fname)
--       end,
--       single_file_support = true,
--       settings = {}
--     },
--   }
-- else
--   print("The tjs_langauge_server is found in official config")
-- end
--
-- lspconfig.tjs_langauge_server.setup {
--   on_attach = custom_attach,
--   capabilities = require("user.lsp.handlers").capabilities,
-- }

-- tjs-language-server end

-- rome-language-server

function os.capture(cmd, raw)
  local handle = assert(io.popen(cmd, 'r'))
  local output = assert(handle:read('*a'))

  handle:close()

  if raw then
    return output
  end

  output = string.gsub(
    string.gsub(
      string.gsub(output, '^%s+', ''),
      '%s+$',
      ''
    ),
    '[\n\r]+',
    ' '
  )

  return output
end

local rome_custom_attach = function(client)
  client.server_capabilities.document_formatting = false
  print("Rome langauge server LSP client.");

end

-- This duplicate exec is just a workaruond, if don't execute at first,
-- the nvim will stuck when you first init rome socket
os.execute("rome __print_socket") -- make sure rome has been in your PATH
local rome_socket = os.capture("rome __print_socket", false)
local rome_bin_name = 'nc'
local rome_cmd = { rome_bin_name, '-U', rome_socket }

if not configs.rome_language_server then
  configs.rome_language_server = {
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
      settings = {
        ["rome"] = {
          analysis = {
            enableCodeActions = true,
            enableDiagnostics = true
          }
        }
      }
    },
    init_options = {
      languageFeatures = {
        diagnostics = true,
      },
    }
  }
else
  print("The rome_language_server is found in official config")
end

lspconfig.rome_language_server.setup {
  on_attach = rome_custom_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- rome-language-server end

local servers = { "jsonls", "sumneko_lua", "tsserver", "rust_analyzer", "zls"}

lsp_installer.setup({
  ensure_installed = servers,
})

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end
  lspconfig[server].setup(opts)
end
