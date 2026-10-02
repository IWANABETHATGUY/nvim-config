-- tjs language server

local custom_attach = function(client)
end

vim.lsp.config.tjs_language_server = {
    cmd = { 'tjs-language-server' },
    cmd_env = {
        RUST_BACKTRACE = '1'
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
    },
    root_markers = { 'package.json', 'node_modules', '.git' },
    settings = {
        ['tjs-postfix'] = {
            ["templateMapList"] = {
                {
                    ["snippetKey"] = "time",
                    ["code"] = "console.time($$)"
                },
                {
                    ["snippetKey"] = "jsons",
                    ["code"] = "JSON.stringify($$)"
                },
                {
                    ["snippetKey"] = "jsonp",
                    ["code"] = "JSON.parse($$)"
                },
                {
                    ["snippetKey"] = "log",
                    ["code"] = "console.log(`$$: `, $$)"
                },
                {
                    ["snippetKey"] = "error",
                    ["code"] = "console.error(`$$: `, $$)"
                },
                {
                    ["snippetKey"] = "warn",
                    ["code"] = "console.warn(`$$: `, $$)",
                },
                {
                    ["snippetKey"] = "req",
                    ["code"] = "require($$)",
                }
            }
        }
    },
    on_attach = custom_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.enable('tjs_language_server')

-- tjs-language-server end
