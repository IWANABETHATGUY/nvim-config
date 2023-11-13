require('leap').add_default_mappings()

require "fidget".setup {
  text = {
    spinner = "moon",        -- animation shown when tasks are ongoing
    done = "✔",            -- character shown when all tasks are complete
    commenced = "Started",   -- message shown when task starts
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
require'marks'.setup {
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
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
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
    hooks = {
        open = { 
          "Telescope find_files" , 
          "Telescope live_grep_args",
          -- "Neotree toggle",
          "HarpoonMarks"
        },
    }
})
