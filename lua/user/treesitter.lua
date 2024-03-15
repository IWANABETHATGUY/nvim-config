local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end


require("nvim-treesitter.parsers").get_parser_configs().just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
    use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
  },
  maintainers = { "@IndianBoy42" },
  filetype = "justfile"
}

require("nvim-treesitter.parsers").get_parser_configs().sway = {
  install_info = {
    url = "https://github.com/FuelLabs/tree-sitter-sway.git", -- local path or git repo
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "master",
    use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
  },
  maintainers = { "@IndianBoy42" },
  filetype = {"sway"}
}

require "nvim-treesitter.install".compilers = { "gcc", "clang" }

configs.setup({
  ensure_installed = "all",      -- one of "all" or a list of languages
  ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,               -- false will disable the whole extension
    -- disable = { "css" },         -- list of language that will be disabled
    disable = function(_, buf)
      local max_filesize = 1024 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
})

-- require("nvim-treesitter.install").command_extra_args = {
--   curl = { "--proxy", "http://127.0.0.1:7890" },
-- }

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt["foldenable"] = false
vim.opt["foldlevel"] = 99

