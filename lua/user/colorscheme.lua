-- Default options
require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,               -- Disable setting background
    terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,              -- Non focused panes set to alternative background
    module_default = true,             -- Default enable value for modules
    colorblind = {
      enable = false,                  -- Enable colorblind support
      simulate_only = false,           -- Only show simulated colorblind colors and not diff shifted
      severity = {
        protan = 0,                    -- Severity [0,1] for protan (red)
        deutan = 0,                    -- Severity [0,1] for deutan (green)
        tritan = 0,                    -- Severity [0,1] for tritan (blue)
      },
    },
    styles = {
    },
    inverse = {
      -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = {
      -- List of various plugins and additional options
      fidget = true,
      neogit = true,
      barbar = true
    },
  },
  palettes = {
    nordfox = {
      -- -- comment is the definition of the comment color.
      comment = "#83b260",
    },

  },
  specs = {
    nordfox = {
    }
  },

  groups = {
    nordfox = {
      LspInlayHint = { fg = "#83b260" },
    }
  },
})

-- setup must be called before loading
vim.cmd("colorscheme nordfox")

vim.cmd("highlight DiffAdd gui=none guifg=none guibg=#103235")
vim.cmd("highlight DiffChange gui=none guifg=none guibg=#272D43")
vim.cmd("highlight DiffText gui=none guifg=none guibg=#394b70")
vim.cmd("highlight DiffDelete gui=none guifg=none guibg=#3F2D3D")
vim.cmd("highlight DiffviewDiffAddAsDelete guibg=#3f2d3d gui=none guifg=none")
vim.cmd("highlight DiffviewDiffDelete gui=none guifg=#3B4252 guibg=none")

-- Left panel
-- "DiffChange:DiffAddAsDelete",
-- "DiffText:DiffDeleteText",
vim.cmd("highlight DiffAddAsDelete gui=none guifg=none guibg=#3F2D3D")
vim.cmd("highlight DiffDeleteText gui=none guifg=none guibg=#4B1818")
--
-- -- Right panel
-- -- "DiffChange:DiffAdd",
-- -- "DiffText:DiffAddText",
vim.cmd("highlight DiffAddText gui=none guifg=none guibg=#1C5458")
