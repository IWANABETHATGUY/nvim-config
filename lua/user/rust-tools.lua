local rt = require("rust-tools")
local handler = require("user.lsp.handlers")

local codelldb_path = "codelldb"
local liblldb_path = "/home/victor/temp/extension/lldb/lib/liblldb.so"

rt.setup({
  tools = {
    hover_actions = {
      auto_focus = true
    }
  },
  server = {
    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
    settings = {
      ["rust-analyzer"] = {
        procMacro = {
          enable = true
        },
        checkOnSave = false,
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
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
      codelldb_path, liblldb_path)
  }
})
