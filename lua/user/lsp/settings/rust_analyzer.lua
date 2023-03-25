return {
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
}
