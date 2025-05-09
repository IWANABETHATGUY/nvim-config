require('leap').add_default_mappings()
require('user.lsp.handlers')

require "fidget".setup {
  text = {
    spinner = "moon", -- animation shown when tasks are ongoing
    done = "✔", -- character shown when all tasks are complete
    commenced = "Started", -- message shown when task starts
    completed = "Completed", -- message shown when task completes
  },
  align = {
    bottom = true, -- align fidgets along bottom edge of buffer
    right = true,  -- align fidgets along right edge of buffer
  },
  timer = {
    spinner_rate = 125,  -- frame rate of spinner animation, in ms
    fidget_decay = 2000, -- how long to keep around empty fidget, in ms
    task_decay = 1000,   -- how long to keep around completed task, in ms
  },
  window = {
    relative = "win", -- where to anchor, either "win" or "editor"
    blend = 100,      -- &winblend for the window
    zindex = nil,     -- the zindex value for the window
    border = "none",  -- style of border for the fidget window
  },
  fmt = {
    leftpad = true,       -- right-justify text in fidget box
    stack_upwards = true, -- list of tasks grows upwards
    max_width = 0,        -- maximum width of the fidget box
    fidget =              -- function to format fidget title
        function(fidget_name, spinner)
          return string.format("%s %s", spinner, fidget_name)
        end,
    task = -- function to format each task line
        function(task_name, message, percentage)
          return string.format(
            "%s%s [%s]",
            message,
            percentage and string.format(" (%s%%)", percentage) or "",
            task_name
          )
        end,
  },
  sources = {
    -- Sources to configure
    ["*"] = {         -- Name of source
      ignore = false, -- Ignore notifications from this source
    },
  },
  debug = {
    logging = false, -- whether to enable logging, for debugging
    strict = false,  -- whether to interpret LSP strictly
  },
}


require("mason").setup()


-- bookmark
require 'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = {},
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {
  }
}

-- workspaces

require("workspaces").setup({
  cd_type = "global",

  -- sort the list of workspaces by name after loading from the workspaces path.
  sort = true,

  -- sort by recent use rather than by name. requires sort to be true
  mru_sort = true,
  hooks = {
    open = {
    },
  }
})


require("dressing").setup({
  input = {
    -- Set to false to disable the vim.ui.input implementation
    enabled = true,

    -- Default prompt string
    default_prompt = "Input:",

    -- Can be 'left', 'right', or 'center'
    title_pos = "left",

    -- When true, <Esc> will close the modal
    insert_only = true,

    -- When true, input will start in insert mode.
    start_in_insert = false,

    -- These are passed to nvim_open_win
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "cursor",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 40,
    width = nil,
    -- min_width and max_width can be a list of mixed types.
    -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },

    buf_options = {},
    win_options = {
      -- Disable line wrapping
      wrap = false,
      -- Indicator for when text exceeds window
      list = true,
      listchars = "precedes:…,extends:…",
      -- Increase this for more context when text scrolls off the window
      sidescrolloff = 0,
    },

    -- Set to `false` to disable
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },

    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,

    -- see :help dressing_get_config
    get_config = nil,
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = true,

    -- Priority list of preferred vim.select implementations
    backend = { "telescope", "fzf", "builtin", "fzf_lua", "nui" },

    -- Trim trailing `:` from prompt
    trim_prompt = true,

    -- Options for telescope selector
    -- These are passed into the telescope picker directly. Can be used like:
    -- telescope = require('telescope.themes').get_ivy({...})
    telescope = nil,

    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },

    -- Options for fzf-lua
    fzf_lua = {
      -- winopts = {
      --   height = 0.5,
      --   width = 0.5,
      -- },
    },

    -- Options for nui Menu
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      buf_options = {
        swapfile = false,
        filetype = "DressingSelect",
      },
      win_options = {
        winblend = 0,
      },
      max_width = 80,
      max_height = 40,
      min_width = 40,
      min_height = 10,
    },

    -- Options for built-in selector
    builtin = {
      -- Display numbers for options and set up keymaps
      show_numbers = true,
      -- These are passed to nvim_open_win
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "editor",

      buf_options = {},
      win_options = {
        cursorline = true,
        cursorlineopt = "both",
      },

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- the min_ and max_ options can be a list of mixed types.
      -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },

      -- Set to `false` to disable
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },

      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end,
    },

    -- Used to override format_item. See :help dressing-format
    format_item_override = {},

    -- see :help dressing_get_config
    get_config = nil,
  },
})

require('crates').setup({
  lsp = {
    enabled = true,
    on_attach = require("user.lsp.handlers").on_attach,
    actions = true,
    completion = true,
    hover = true,
  },
})

vim.g.translator_proxy_url = 'socks5://127.0.0.1:7890'


require("nvim-lightbulb").setup({
  autocmd = { enabled = true }
})

require('blink.cmp').setup({
  keymap = {
    preset = 'enter',
    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },

    ["<M-l>"] = {
      function(cmp)
        if vim.b[vim.api.nvim_get_current_buf()].nes_state then
          cmp.hide()
          return (
            require("copilot-lsp.nes").apply_pending_nes()
            and require("copilot-lsp.nes").walk_cursor_end_edit()
          )
        end
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
  },
  enabled = function()
    return not vim.tbl_contains({ "nofile", "prompt" }, vim.bo.buftype)
        -- return vim.bo.buftype ~= "nofile"
        and vim.b.completion ~= false
  end,
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  completion = {
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned

    -- experimental auto-brackets support
    accept = {
      -- expand_snippet = function(snippet) require('luasnip').lsp_expand(snippet) end,
      auto_brackets = {
        enabled = false,
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  cmdline = {
    -- Disable cmdline completions
    enabled = false,
  },
  sources = {
    -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
    default = { 'lsp', 'path', 'snippets', 'buffer', "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
    },
  },
  signature = { enabled = true },
  -- 'default' for mappings similar to built-in completion
  -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
  -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
  -- see the "default configuration" section below for full documentation on how to define
  -- your own keymap.
  -- sources = {
  --   completion = {
  --     -- WARN: add the rest of your providers here, unless you're using `opts_extend`
  --     -- and defining this outside of your primary `blink.cmp` config
  --     -- see the default configuration for the default providers
  --     enabled_providers = { 'luasnip' },
  --   },
  --   providers = {
  --     luasnip = {
  --       name = 'luasnip',
  --       module = 'blink.compat.source',
  --
  --       score_offset = -3,
  --
  --       opts = {
  --         use_show_condition = false,
  --         show_autosnippets = true,
  --       },
  --     },
  --   },
  -- },

  -- experimental signature help support
  -- trigger = { signature_help = { enabled = true } },

});

require('modes').setup({
  colors = {
    bg = "", -- Optional bg param, defaults to Normal hl group
    copy = "#f5c359",
    delete = "#c75c6a",
    insert = "#78ccc5",
    visual = "#9745be",
  },

  -- Set opacity for cursorline and number background
  line_opacity = 0.15,

  -- Enable cursor highlights
  set_cursor = true,

  -- Enable cursorline initially, and disable cursorline for inactive windows
  -- or ignored filetypes
  set_cursorline = true,

  -- Enable line number highlights to match cursorline
  set_number = true,

  -- Disable modes highlights in specified filetypes
  -- Please PR commonly ignored filetypes
  ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
})
