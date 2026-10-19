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
    workspace_required = true,
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
    cmd = { 'emmylua_ls' },
    capabilities = require("user.lsp.handlers").capabilities,
    on_attach = require("user.lsp.handlers").on_attach,
}


vim.lsp.config.ruff = {
    cmd = { 'ruff', 'server' }
}

local vue_language_server_path = vim.fn.expand('$MASON') ..
    '/packages/vue-language-server/node_modules/@vue/language-server'


-- A buffer is in a Vue project when some package.json above it depends on vue
local function in_vue_project(bufnr)
    return vim.fs.root(bufnr, function(name, path)
        if name ~= 'package.json' then
            return false
        end
        local ok, pkg = pcall(vim.json.decode, table.concat(vim.fn.readfile(vim.fs.joinpath(path, name)), '\n'))
        if not ok or type(pkg) ~= 'table' then
            return false
        end
        for _, field in ipairs({ 'dependencies', 'devDependencies', 'peerDependencies' }) do
            if type(pkg[field]) == 'table' and pkg[field].vue then
                return true
            end
        end
        return false
    end) ~= nil
end

-- TypeScript 7 native server; it cannot load tsserver plugins, so Vue projects stay on vtsls.
-- Keep cmd and root_dir from one load of lsp/tsc.lua: they share the cache of the selected binary
local tsc_defaults = vim.lsp.config.tsc
vim.lsp.config.tsc = {
    cmd = tsc_defaults.cmd,
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
    root_dir = function(bufnr, on_dir)
        if not in_vue_project(bufnr) then
            tsc_defaults.root_dir(bufnr, on_dir)
        end
    end,
}

vim.lsp.config('vue_ls', {})
local vtsls_root_dir = vim.lsp.config.vtsls.root_dir
vim.lsp.config.vtsls = {
    cmd = { 'vtsls', '--stdio' },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    root_dir = function(bufnr, on_dir)
        if vim.bo[bufnr].filetype == 'vue' or in_vue_project(bufnr) then
            vtsls_root_dir(bufnr, on_dir)
        end
    end,
    settings = {
      typescript = {
        tsserver = {
          -- The default 3072 MB heap is too small for large monorepos; tsserver aborts with OOM
          maxTsServerMemory = 12288,
        },
      },
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
    -- tsc is the fallback for projects that do not have TypeScript 7 in node_modules
    ensure_installed = vim.list_extend({ "tsc" }, servers),
    automatic_enable = {
        exclude = {
            "vtsls",
            "emmylua_ls",
            -- Off by default; start it on demand with `:lsp enable tsc`
            "tsc",
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

-- Enable all configured LSP servers except tsc, which starts on demand
vim.lsp.enable({
    'zls', 'taplo', 'racket_langserver', 'ocamllsp',
    'move_analyzer', 'emmylua_ls', 'ruff', 'vtsls', 'vue_ls',
    'jsonls', 'clangd', 'pyright', 'asm_lsp'
})
