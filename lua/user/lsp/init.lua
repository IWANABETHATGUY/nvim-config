local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.configs"
require("user.lsp.handlers").setup()
require "user.lsp.null-ls"

-- require('lspconfig').tjs_language_server.setup()
-- require('lspconfig').rust_analyzer.setup()


-- rust-analyzer
