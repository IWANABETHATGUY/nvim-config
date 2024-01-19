local rt = require("rust-tools")
local handler = require("user.lsp.handlers")

local codelldb_path = "codelldb"
local liblldb_path = "/home/victor/temp/extension/lldb/lib/liblldb.so"

local util = require('lspconfig.util')

local rustPorjectDir = nil
local function rustRootPattern(fname)
  local cargo_crate_dir = util.root_pattern 'Cargo.toml' (fname)
  local cmd = { 'cargo', 'metadata', '--no-deps', '--format-version', '1' }
  if cargo_crate_dir ~= nil then
    cmd[#cmd + 1] = '--manifest-path'
    cmd[#cmd + 1] = util.path.join(cargo_crate_dir, 'Cargo.toml')
  end
  local cargo_metadata = ''
  local cargo_metadata_err = ''
  local cm = vim.fn.jobstart(cmd, {
    on_stdout = function(_, d, _)
      cargo_metadata = table.concat(d, '\n')
    end,
    on_stderr = function(_, d, _)
      cargo_metadata_err = table.concat(d, '\n')
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
  if cm > 0 then
    cm = vim.fn.jobwait({ cm })[1]
  else
    cm = -1
  end
  local cargo_workspace_dir = nil
  if cm == 0 then
    cargo_workspace_dir = vim.json.decode(cargo_metadata)['workspace_root']
    if cargo_workspace_dir ~= nil then
      cargo_workspace_dir = util.path.sanitize(cargo_workspace_dir)
    end
  else
    vim.notify(
      string.format('[lspconfig] cmd (%q) failed:\n%s', table.concat(cmd, ' '), cargo_metadata_err),
      vim.log.levels.WARN
    )
  end
  return cargo_workspace_dir
      or cargo_crate_dir
      or util.root_pattern 'rust-project.json' (fname)
      or util.find_git_ancestor(fname)
  -- return cargo_crate_dir
  --     or util.root_pattern 'rust-project.json' (fname)
  --     or util.find_git_ancestor(fname)
end

local function rust_root_dir(fname)
  local function get()
    rustPorjectDir = rustRootPattern(fname)
    vim.notify("Directory: " .. rustPorjectDir, "info", { title = "Rust project opened" })
    return rustPorjectDir
  end

  return rustPorjectDir or get()
end

-- lsp.configure("rust_analyzer", {
--   root_dir = rust_root_dir,
-- })
rt.setup({
  tools = {
    hover_actions = {
      auto_focus = true
    },
    inlay_hints  = {
      auto = false
    },
  },
  server = {
    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
    root_dir = rust_root_dir,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "self",
        },
        numThreads = 16,
        cargo = {
          loadOutDirsFromCheck = false
        },
        checkOnSave = false,
        procMacro = {
          enable = true,
          ignored = {
            ['napi-derive'] = { 'napi' },
          },
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
    -- on_attach = function(client, bufnr)
    --   -- Hover actions
    -- end,
  },
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
      codelldb_path, liblldb_path)
  }
})
