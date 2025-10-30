
local FTerm = require('FTerm')
-- Store cursor position globally
_G.fterm_state = {
  cursor = nil,
  win = nil,
  mode = nil,
}
    
    -- Enhanced toggle with mode restoration
_G.fterm_toggle = function()
  local FTerm = require('FTerm')
  
  if FTerm.is_win_valid() then
    -- Closing terminal
    
    vim.schedule(function()
      -- Force normal mode first
      vim.cmd('stopinsert')
      
      -- Restore cursor position
      if _G.fterm_state.cursor and _G.fterm_state.win then
        if vim.api.nvim_win_is_valid(_G.fterm_state.win) then
          pcall(vim.api.nvim_win_set_cursor, _G.fterm_state.win, _G.fterm_state.cursor)
        end
      end
      
      FTerm.close()
      -- Restore mode (if was in insert mode)
      if _G.fterm_state.mode == 'i' then
        vim.cmd('startinsert')
      elseif _G.fterm_state.mode == 'v' or _G.fterm_state.mode == 'V' then
        vim.cmd('normal! gv')  -- Restore visual selection
      end
      -- Otherwise stay in normal mode (default)
    end)
  else
    -- Opening terminal
    _G.fterm_state.win = vim.api.nvim_get_current_win()
    _G.fterm_state.cursor = vim.api.nvim_win_get_cursor(_G.fterm_state.win)
    _G.fterm_state.mode = vim.fn.mode()  -- Save current mode
    
    FTerm.open()
    vim.cmd('stopinsert')
  end
end
require'FTerm'.setup({
    border = 'double',
    dimensions  = {
        height = 0.9,
        width = 0.9,
    },
})

-- Example keybindings
vim.keymap.set('n', '<c-\\>', '<CMD>lua fterm_toggle()<CR>')
vim.keymap.set('t', '<c-\\>', '<C-\\><C-n><CMD>lua fterm_toggle()<CR>')


function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end


vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


