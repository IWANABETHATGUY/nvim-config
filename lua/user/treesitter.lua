local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end


require("nvim-treesitter.install").command_extra_args = {
    -- curl = { "--proxy", "http://127.0.0.1:7890" },
}

require("nvim-treesitter.parsers").get_parser_configs().just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
    use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
  },
  maintainers = { "@IndianBoy42" },
}

require"nvim-treesitter.install".compilers = {"gcc", "clang"}

configs.setup({
	ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
})

require("nvim-treesitter.install").command_extra_args = {
    curl = { "--proxy", "http://127.0.0.1:7890" },
}