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
  -- {
  --   -- used for A panel to view the logs from your LSP servers.
  --   "mhanberg/output-panel.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("output_panel").setup()
  --   end
  -- },
  { 'kosayoda/nvim-lightbulb' },
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
  ({
    'ggandor/leap.nvim'
  }),

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
  -- ({ "numToStr/Comment.nvim", commit = "2c26a00f32b190390b664e56e32fd5347613b9e2" }),
  ({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269" }),
  ({ "kyazdani42/nvim-web-devicons", commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e" }),
  {
    'nvim-treesitter/nvim-treesitter-context',
  },
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', --recommended as each new version will have breaking changes
    opts = {
      --Config goes here
    },
  },
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
  {
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        -- animation = true,
        -- insert_at_start = true,
        -- …etc.
      }
    },
  },
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
  { "EdenEast/nightfox.nvim" },

  {
    "wsdjeg/vim-fetch"
  },
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["I Return"] = "<S-CR>",
      }
    end
  },

  {
    'saecki/crates.nvim',
    branch = 'main',
    config = function()
    end,
  },

  -- snippets
  {
    'mcauley-penney/visual-whitespace.nvim',
    config = {
      highlight = { link = "Visual" },
      space_char = '·',
      tab_char = '→',
      nl_char = '↲',
      cr_char = '←',
      enabled = true,
      excluded = {
        filetypes = { "neo-tree" },
        buftypes = { "terminal", "nofile" },
      }
    }
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"

      },
    },
    lazy = false, -- lazy loading handled internally
    -- use a release tag to download pre-built binaries
    version = '1.2.0',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" }
  },

  -- LSP servers and clients communicate what features they support through "capabilities".
  --  By default, Neovim support a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in general for nvim-lspconfig:

  -- LSP
  {
    "neovim/nvim-lspconfig",
    inlay_hints = { enabled = true },
  }, -- enable LSP
  {
    "mvllow/modes.nvim",
  },
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
  {
    "jmacadie/telescope-hierarchy.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        hierarchy = {
          -- telescope-hierarchy.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("hierarchy")
    end,
  },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
  },

  {
    "j-hui/fidget.nvim",
    tag = "v1.0.0", -- Make sure to update this to something recent!
    opts = {
      -- options
    },
  },

  -- Git
  { "lewis6991/gitsigns.nvim" },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "gl", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
    },
  },
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  {
    'mrcjkb/rustaceanvim',
    version = '6.0.10', -- Recommended
    lazy = false,       -- This plugin is already lazy
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
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitute_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({})
    end
  },
  { "nvim-neotest/nvim-nio" },
  { "niuiic/translate.nvim" },
  { "niuiic/omega.nvim",    build = "cd rs && cargo build --release" },
  -- Debug
  {
    'mfussenegger/nvim-dap'
  },
  --  { '~/.config/nvim/lua/r/restart_ls' },
  { dir = '~/Documents/nvim/file-position-matcher', build = "./install.sh",                    lazy = false },
  { "rcarriga/nvim-dap-ui",                         dependencies = { "mfussenegger/nvim-dap" } },
})
