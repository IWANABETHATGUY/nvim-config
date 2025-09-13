local opts = { noremap = true, silent = true }
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function select_item(items)
  pickers.new({}, {
    prompt_title = "Choose an option",
    finder = finders.new_table({
      results = items,
      entry_maker = function(item)
        return {
          value = item,
          display = item.name,
          ordinal = item.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if entry then
          local item = entry.value
          vim.cmd(string.format("e %s", item['path']))
          vim.defer_fn(function()
            vim.fn.cursor(item['row'] or 0, item['col'] or 0)
          end, 50) -- Delay in milliseconds (adjust if needed)
        end
      end)
      return true
    end,
  }):find()
end

local M = {}
function M.get_register_and_eval()
  local current_line = vim.api.nvim_get_current_line()

  vim.cmd("ToggleTerm")
  local matcher = require('matcher')
  local ret = matcher.add(current_line, vim.loop.cwd())
  if ret ~= nil then
    if #ret == 1 then
      local item = ret[1]
      vim.cmd(string.format("e %s", item['path']))
      vim.defer_fn(function()
        vim.fn.cursor(item['row'] or 0, item['col'] or 0)
      end, 50) -- Delay in milliseconds (adjust if needed)
      return
    end
    select_item(ret)
  else
    print(current_line)
  end
end

vim.api.nvim_set_keymap("n", "ge", ":GotoLinkedFile<CR>", opts)

vim.api.nvim_create_user_command('GotoLinkedFile', function()
  vim.cmd(":lua require('user.goto-file').get_register_and_eval()")
end, {})

return M;
