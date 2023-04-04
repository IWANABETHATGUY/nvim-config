local rt = require("rust-tools")
local handler = require("user.lsp.handlers")

rt.setup({
  tools = {
    hover_actions = {
      auto_focus = true
    }
  },
  server = {
    on_attach = handler.on_attach,
    -- on_attach = function(client, bufnr)
    --   -- Hover actions
    -- end,
  },
})
