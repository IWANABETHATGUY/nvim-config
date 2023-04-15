local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.configs"
require("user.lsp.handlers").setup()
require("user.lsp.settings.tjs_language_server")
-- require("user.lsp.settings.rome_language_server")


-- rust-analyzer
