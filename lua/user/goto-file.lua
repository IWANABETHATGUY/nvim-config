local opts = { noremap = true, silent = true }
local M = {}
function M.get_register_and_eval()
  -- local current_word = vim.call('expand', '<cword>')
  -- local currentLine = vim.call('getline', '.')
  -- print(currentLine)
  --
  -- local regex = "%b<>%s+(%S+:%d+:%d+)"
  -- local match = string.match(currentLine, regex)

  local register = vim.fn.getreg('"')
  vim.cmd(string.format("e %s", register))
end

vim.api.nvim_set_keymap("n", "ge", ":lua require('user.goto-file').get_register_and_eval()<CR>", opts)

return M;
