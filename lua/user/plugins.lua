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
    dependencies = { 'antoinemadec/FixCursorHold.nvim' },
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      vim.g.maplocalleader = ','
      require('grug-far').setup({
      });
    end
  },
  {
    "natecraddock/workspaces.nvim"
  },
  {
    "aznhe21/actions-preview.nvim",
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim" -- optional
    },
    config = true
  },
  ({
    'ggandor/leap.nvim'
  }),
  -- color picker
  -- {
  --   "uga-rosa/ccc.nvim",
  --   branch = "0.7.2"
  -- },


  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          rust = true,
          javascript = true,
          typescript = true,
          vue = true,
          python = true,
          sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
              -- disable for .env files
              return false
            end
            return true
          end,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
          },
        },
      })
    end,
  },
  ({ "nvim-lua/plenary.nvim", commit = "968a4b9afec0c633bc369662e78f8c5db0eba249" }), -- full lua functions d by lots of plugins
  ({ "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" }), -- Autopairs, integrates with both cmp and treesitter
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
  { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
  'romgrk/barbar.nvim',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  "numToStr/FTerm.nvim",
  ({ "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" }),
  "lukas-reineke/indent-blankline.nvim",
  ("folke/which-key.nvim"),
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  },
  { 'stevearc/dressing.nvim' },
  { "EdenEast/nightfox.nvim" }, -- Packer

  {
    "wsdjeg/vim-fetch"
  },
  {
    "mg979/vim-visual-multi"
  },

  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
    end,
  },
  -- cmp plugins
  ({ "hrsh7th/nvim-cmp" }),         -- The completion plugin
  ({ "hrsh7th/cmp-buffer" }),       -- buffer completions
  ({ "hrsh7th/cmp-path" }),         -- path completions
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
  {
    "neovim/nvim-lspconfig",
    inlay_hints = { enabled = true },
  }, -- enable LSP
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "williamboman/mason.nvim",
    run = ":MasonUpdate"          -- :MasonUpdate updates registry contents
  },
  ({ "nvimtools/none-ls.nvim" }), -- for formatters and linters
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    },
    config = function()
    end
  },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
  },

  { "IndianBoy42/tree-sitter-just" },
  { "FuelLabs/tree-sitter-sway" },
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
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'sindrets/diffview.nvim',             dependencies = { 'nvim-lua/plenary.nvim' } },

  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  {
    'mrcjkb/rustaceanvim',
    version = '5.2.3', -- Recommended
    lazy = false,      -- This plugin is already lazy
  },
  { 'chentoast/marks.nvim' },
  {
    "cbochs/grapple.nvim",
    opts = {
      scope = "git", -- also try out "git_branch"
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple"
  },
  { "nvim-neotest/nvim-nio" },
  -- Debug
  { 'voldikss/vim-translator' },
  {
    'mfussenegger/nvim-dap'
  },
  --  { '~/.config/nvim/lua/r/restart_ls' },
  { dir = '~/Documents/nvim/file-position-matcher', build = "./install.sh",                    lazy = false },
  { "rcarriga/nvim-dap-ui",                         dependencies = { "mfussenegger/nvim-dap" } },
})
