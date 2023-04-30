local lspconfig = require("lspconfig")

lspconfig.zls.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

lspconfig.lua_ls.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

-- lua config
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- lua config end

lspconfig.taplo.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

lspconfig.racket_langserver.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

lspconfig.ocamllsp.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

lspconfig.denols.setup {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  single_file_support = false
}

-- lspconfig.tsserver.setup {
--   on_attach = require("user.lsp.handlers").on_attach,
--   capabilities = require("user.lsp.handlers").capabilities,
-- }

local servers = { "jsonls", "clangd", "tsserver", "ocamllsp" }
require("mason-lspconfig").setup {
  ensure_installed = servers
}

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
