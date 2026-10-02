-- diffview-plus.nvim (actively maintained fork of sindrets/diffview.nvim).
-- Only non-default options are listed; see `:h diffview-config` and `:h diffview.changelog`.
-- Default keymaps are used as-is (`g?` in any panel shows them).
require("diffview").setup({
  enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
  view = {
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_mixed",
    },
  },
  file_history_panel = {
    log_options = { -- See |diffview-config-log_options|
      git = {
        single_file = {
          diff_merges = "combined",
        },
      },
    },
  },
  hooks = {
    view_opened = function(view)
      local utils = require("user.utils");
      -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
      -- the right.
      local function post_layout()
        utils.tbl_ensure(view, "winopts.diff2.a")
        utils.tbl_ensure(view, "winopts.diff2.b")
        -- left
        view.winopts.diff2.a = utils.tbl_union_extend(view.winopts.diff2.a, {
          winhl = {
            "DiffChange:DiffAddAsDelete",
            "DiffText:DiffDeleteText",
          },
        })
        -- right
        view.winopts.diff2.b = utils.tbl_union_extend(view.winopts.diff2.b, {
          winhl = {
            "DiffChange:DiffAdd",
            "DiffText:DiffAddText",
          },
        })
      end

      view.emitter:on("post_layout", post_layout)
      post_layout()
    end,
  },
})
