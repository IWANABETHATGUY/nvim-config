-- rome-language-server

local util = require 'lspconfig.util'
local config = require('lspconfig.configs')

-- This duplicate exec is just a workaruond, if don't execute at first,
-- the nvim will stuck when you first init rome socket
local rome_cmd = { 'rome', 'lsp-proxy' }
local capabilities = require("user.lsp.handlers").capabilities

config.rome_language_server = {
  default_config = {
    cmd = rome_cmd,
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'json'
    },
    root_dir = util.root_pattern("rome.json"),
    single_file_support = true,
  },
}

-- local merged_table = vim.tbl_extend("keep", {
--   textDocument = {
--     formatting = {
--       dynamicRegistration = true
--     }
--   }
-- }, capabilities);
--
config.rome_language_server.setup {
  on_attach = function(client, buf)
    print(vim.inspect(capabilities.textDocument.formatting.dynamicRegistration))
    require("user.lsp.handlers").on_attach(client, buf)
  end,
  capabilities = capabilities,
}
