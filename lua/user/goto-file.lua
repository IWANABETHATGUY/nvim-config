local fterm = require('FTerm')
local opts = { noremap = true, silent = true }

local M = {}
function M.get_register_and_eval()
  -- local current_word = vim.call('expand', '<cword>')
  -- local currentLine = vim.call('getline', '.')
  -- print(currentLine)
  --
  -- local regex = "%b<>%s+(%S+:%d+:%d+)"
  -- local match = string.match(currentLine, regex)
  --  local util = vim.lsp.util
  -- local api = vim.api
  --  local wc = 0
  --  local windows = vim.api.nvim_tabpage_list_wins(0)
  --
  -- for _, v in pairs(windows) do
  --   local cfg = vim.api.nvim_win_get_config(v)
  --   local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "filetype")
  --
  --   if (cfg.relative == "" or cfg.external == false) and ft ~= "qf" then
  --     wc = wc + 1
  --   end
  -- end

  -- if result[1].uri ~= ctx.params.textDocument.uri and wc < 3 then
  --   vim.cmd(split_cmd)
  -- end
  -- start: { line: 5, character: 23 },
  --    end : { line: 6, character: 0 }
  -- util.jump_to_location({
  --   -- uri = "file:///Users/bytedance/.config/nvim/init.lua",
  --   uri = "file:///Users/bytedance/Documents/rust/hello",
  --   location = {
  --     start = {line = 0, character =  0},
  --     ["end"] = {line =  0, character =  0}
  --   },
  --   true
  --
  -- }, "utf-8")

  -- if #result > 1 then
  --   util.set_qflist(util.locations_to_items(result))
  --   api.nvim_command("copen")
  --   api.nvim_command("wincmd p")
  -- end

  local current_line = vim.api.nvim_get_current_line()

  fterm.close()
  local matcher = require('matcher')
  local res = matcher.add(current_line)
  if res ~= nil then
    lines = {}
    for s in res:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    if #lines == 1 then
      vim.cmd(string.format("e %s", lines[1]))
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
