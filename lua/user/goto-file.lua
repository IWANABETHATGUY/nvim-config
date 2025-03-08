local fterm = require('FTerm')
local opts = { noremap = true, silent = true }

local M = {}
function M.get_register_and_eval()
  local current_line = vim.api.nvim_get_current_line()

  fterm.close()
  local matcher = require('matcher')
  local ret = matcher.add(current_line, vim.loop.cwd())
  if ret ~= nil then
    if true then
      vim.cmd(string.format("e %s", ret[1]))
      vim.defer_fn(function()
        vim.fn.cursor(ret[2] or 0, ret[3] or 0)
      end, 50) -- Delay in milliseconds (adjust if needed)
      return
    end
    vim.ui.select(lines, {
      prompt = "Select a path",
    }, function(item, _)
      if item ~= nil then
        vim.cmd(string.format("e %s", item))
      end
    end)
  else
    print(current_line)
  end
end

vim.api.nvim_set_keymap("n", "ge", ":GotoLinkedFile<CR>", opts)

vim.api.nvim_create_user_command('GotoLinkedFile', function()
  vim.cmd(":lua require('user.goto-file').get_register_and_eval()")
end, {})

return M;
