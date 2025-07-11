local handler = require("user.lsp.handlers")

vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
        float_win_config = {
            auto_focus = true
        }
    },
    dap = {
        autoload_configurations = false
    },
    -- LSP configuration
    server = {
        on_attach = handler.on_attach,
        capabilities = handler.capabilities,
        settings = {
            ["rust-analyzer"] = {
                lru = {
                    capacity = 24,
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                hover = {
                    actions = {
                        debug = {
                            enable = false
                        }
                    },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ['napi-derive'] = { 'napi' },
                    },
                },
                -- checkOnSave = false,
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
    },
}

vim.g.rustaceanvim.tools.test_executor = 'background'
