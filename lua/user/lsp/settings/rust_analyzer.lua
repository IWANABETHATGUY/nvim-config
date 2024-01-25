return {
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "self",
      },
      cargo = {
        loadOutDirsFromCheck = false
      },
      procMacro = {
        enable = true
      },
      checkOnSave = true,
      completion = {
        snippets = {
          custom = {
            ["println!"] = {
              ["postfix"] = "println",
              ["body"] = {
                "println!(\"$0\", ${receiver});"
              },
              ["description"] = "println!()"
              ["scope"] = "expr"
            },
            ["Arc::new"] = {
              postfix = "arc",
              body = "Arc::new(${receiver})",
              requires = "std::sync::Arc",
              description = "Put the expression into an `Arc`",
              scope = "expr"
            },
            ["Rc::new"] = {
              postfix = "rc",
              body = "Rc::new(${receiver})",
              requires = "std::rc::Rc",
              description = "Put the expression into an `Rc`",
              scope = "expr"
            },
            ["Box::pin"] = {
              postfix = "pinbox",
              body = "Box::pin(${receiver})",
              requires = "std::boxed::Box",
              description = "Put the expression into a pinned `Box`",
              scope = "expr"
            },
            Ok = {
              postfix = "ok",
              body = "Ok(${receiver})",
              description = "Wrap the expression in a `Result::Ok`",
              scope = "expr"
            },
            Err = {
              postfix = "err",
              body = "Err(${receiver})",
              description = "Wrap the expression in a `Result::Err`",
              scope = "expr"
            },
            Some = {
              ["postfix"] = "some",
              ["body"] = "Some(${receiver})",
              ["description"] = "Wrap the expression in an `Option::Some`",
              ["scope"] = "expr"
            }
          }
        }
      },
    }
  },
}
