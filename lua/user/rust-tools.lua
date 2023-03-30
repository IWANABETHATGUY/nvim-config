local rt = require("rust-tools")
local handler = require("user.lsp.handlers")

rt.setup({
  server = {
    on_attach = handler.on_attach
    -- on_attach = function(_, bufnr)
    --   -- Hover actions
    --   vim.keymap.set("n", "gh", rt.hover_actions.hover_actions, { buffer = bufnr })
    --   -- Code action groups
    --   vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    -- end,
  },
})
