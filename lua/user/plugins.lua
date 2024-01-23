local fn = vim.fn

-- Install your plugins here
require("lazy").setup({
  -- My plugins here
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
   {
    'kosayoda/nvim-lightbulb',
    dependencies = {'antoinemadec/FixCursorHold.nvim'},
  },
   {
    "natecraddock/workspaces.nvim"
  },
  ({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  }),

  ({
    'ggandor/leap.nvim'
  }),

  --  {'github/copilot.vim', branch = 'release' }
  ({ "wbthomason/packer.nvim", commit = "00ec5adef58c5ff9a07f11f45903b9dbbaa1b422" }), -- Have packer manage itself
  ({ "nvim-lua/plenary.nvim", commit = "968a4b9afec0c633bc369662e78f8c5db0eba249" }),  -- ful lua functions d by lots of plugins
  ({ "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" }),  -- Autopairs, integrates with both cmp and treesitter
  ({ "numToStr/Comment.nvim", commit = "2c26a00f32b190390b664e56e32fd5347613b9e2" }),
  ({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269" }),
  ({ "kyazdani42/nvim-web-devicons", commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e" }),
  {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
  },
  ({ "akinsho/bufferline.nvim", commit = "c78b3ecf9539a719828bca82fc7ddb9b3ba0c353" }),
   'romgrk/barbar.nvim',
  ({ "nvim-lualine/lualine.nvim", commit = "3362b28f917acc37538b1047f187ff1b5645ecdd" }),

   "numToStr/FTerm.nvim",
  ({ "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" }),

   "lukas-reineke/indent-blankline.nvim",
  ({ "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" }),
  ("folke/which-key.nvim"),

  -- Colorschemes
  -- ({ "folke/tokyonight.nvim", branch = "main" })
  --  { "catppuccin/nvim", as = "catppuccin" }
  -- ("lunarvim/darkplus.nvim")
  --  'shaunsingh/nord.nvim'


   {'stevearc/dressing.nvim'},
   "EdenEast/nightfox.nvim", -- Packer

   {
    "wsdjeg/vim-fetch"
  },
   {
    "mg979/vim-visual-multi"
  },

  -- cmp plugins
  ({ "hrsh7th/nvim-cmp" }),         -- The completion plugin
  ({ "hrsh7th/cmp-buffer" }),      -- buffer completions
  ({ "hrsh7th/cmp-path" }),        -- path completions
  ({ "saadparwaiz1/cmp_luasnip" }), -- snippet completions
  ({ "hrsh7th/cmp-nvim-lsp" }),
  ({ "hrsh7th/cmp-nvim-lua" }),

  -- snippets
  ({
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    branch = "master", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    run = "make install_jsregexp"
  }),
  ({ "rafamadriz/friendly-snippets", commit = "d27a83a363e61009278b6598703a763ce9c8e617" }), -- a bunch of snippets to 

  -- LSP
  { "neovim/nvim-lspconfig"}, -- enable LSP
   {
    "williamboman/mason-lspconfig.nvim",
  },
   {
    "williamboman/mason.nvim",
    run = ":MasonUpdate"                     -- :MasonUpdate updates registry contents
  },
  ({ "jose-elias-alvarez/null-ls.nvim" }), -- for formatters and linters
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { 
          "nvim-telescope/telescope-live-grep-args.nvim" ,
          -- This will not install any breaking changes.
          -- For major updates, this must be adjusted manually.
          version = "^1.0.0",
      },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    },
    config = function()
    end
  },
  -- Repalce tool
   "nvim-pack/nvim-spectre",
  -- Treesitter
   {
    'nvim-treesitter/nvim-treesitter',
  },

   'nvim-treesitter/playground',
   { "IndianBoy42/tree-sitter-just" },
   {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require("fidget").setup {
        -- options
      }
    end,
  },

  -- Git
  { "lewis6991/gitsigns.nvim" },
   { "kdheepak/lazygit.nvim" },

   {
    'ruifm/gitlinker.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
  },
   { 'sindrets/diffview.nvim', dependencies = {'nvim-lua/plenary.nvim'} },
  --  { 'github/copilot.vim' }

  -- rust
   { 'simrat39/rust-tools.nvim' },
   { 'hrsh7th/cmp-nvim-lsp-signature-help' },


   {'ThePrimeagen/harpoon', dependencies = {"nvim-lua/plenary.nvim"}},
   { 'chentoast/marks.nvim' },

  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
   "jubnzv/virtual-types.nvim",
  -- Debug


   {
    'mfussenegger/nvim-dap'
  },
  --  { '~/.config/nvim/lua/r/restart_ls' },
   { dir = '~/Documents/nvim/file-position-matcher', build = "./install.sh", lazy = false },
   { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
})
