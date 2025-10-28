vim.lsp.config.zls = {
    cmd = { 'zls' },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

-- lua config
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


-- lua config end

vim.lsp.config.taplo = {
    cmd = { 'taplo', 'lsp', 'stdio' },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.config.racket_langserver = {
    cmd = { 'racket', '--lib', 'racket-langserver' },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.config.ocamllsp = {
    cmd = { 'ocamllsp' },
    on_attach = function(client, bufnr)
        require('virtualtypes').on_attach(client, bufnr)
        require("user.lsp.handlers").on_attach(client, bufnr)
    end,
    capabilities = require("user.lsp.handlers").capabilities,
}

-- vim.lsp.config.denols = {
--     cmd = { 'deno', 'lsp' },
--     on_attach = require("user.lsp.handlers").on_attach,
--     capabilities = require("user.lsp.handlers").capabilities,
--     root_markers = { "deno.json", "deno.jsonc" },
--     single_file_support = false
-- }

vim.lsp.config.move_analyzer = {
    cmd = { "sui-move-analyzer" },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
    root_markers = { "Move.toml" },
    single_file_support = false
}


-- configs.emmylua_ls = {
--   default_config = {
--     cmd = { 'just-lsp' },
--     root_dir = function(fname)
--       return util.find_git_ancestor(fname)
--     end,
--     filetypes = {
--       'just',
--     },
--     single_file_support = true
--   },
-- }

-- lspconfig.emmylua_ls.setup {
--     on_attach = require("user.lsp.handlers").on_attach,
--     capabilities = require("user.lsp.handlers").capabilities,
-- }
vim.lsp.config.emmylua_ls = {
    cmd = { 'emmylua-language-server' },
    capabilities = require("user.lsp.handlers").capabilities,
    on_attach = require("user.lsp.handlers").on_attach,
}


vim.lsp.config.ruff = {
    cmd = { 'ruff', 'server' }
}

-- lspconfig.copilot_ls.setup {}

local vue_language_server_path = vim.fn.expand('$MASON') ..
    '/packages/vue-language-server/node_modules/@vue/language-server'


vim.lsp.config('vue_ls', {})
vim.lsp.config.vtsls = {
    cmd = { 'vtsls', '--stdio' },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {
      vtsls = {
        -- autoUseWorkspaceTsdk = true,
        tsserver = {
          globalPlugins = {
            {
              name = '@vue/typescript-plugin',
              location = vue_language_server_path,
              languages = { 'vue' },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
    },
}


-- lspconfig.volar.setup {
--     on_attach = require("user.lsp.handlers").on_attach,
--     capabilities = require("user.lsp.handlers").capabilities,
-- }

local servers = { "jsonls", "clangd", "pyright", "asm_lsp", "emmylua_ls" }

require("mason-lspconfig").setup {
    ensure_installed = servers,
    automatic_enable = {
        exclude = {
            "vtsls",
            "emmylua_ls"
        }
    }
}

-- Default command configurations for servers handled by mason
local default_cmds = {
    jsonls = { 'vscode-json-language-server', '--stdio' },
    clangd = { 'clangd' },
    pyright = { 'pyright-langserver', '--stdio' },
    asm_lsp = { 'asm-lsp' },
}

for _, server in pairs(servers) do
    local opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    -- Add default cmd if available
    if default_cmds[server] then
        opts.cmd = default_cmds[server]
    end

    local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
    if has_custom_opts then
        opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
    end

    if server ~= "emmylua_ls" then
        vim.lsp.config[server] = opts
    end
end

-- Enable all configured LSP servers
vim.lsp.enable({
    'zls', 'taplo', 'racket_langserver', 'ocamllsp',
    'move_analyzer', 'emmylua_ls', 'ruff', 'vtsls', 'vue_ls',
    'jsonls', 'clangd', 'pyright', 'asm_lsp'
})
