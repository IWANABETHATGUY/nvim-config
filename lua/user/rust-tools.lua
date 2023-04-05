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
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "self",
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        },
        completion = {
          snippets = {
            custom = {
              ["println!"] = {
                ["postfix"] = "println",
                ["body"] = {
                  "println!(\"$0\", ${receiver});"
                },
                ["description"] = "println!()",
                ["scope"] = "expr"
              }
            }
          }
        },
      }
    },
    -- on_attach = function(client, bufnr)
    --   -- Hover actions
    -- end,
  },
})
