vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=co
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup _lsp
    autocmd!
    autocmd BufWritePre *.rs lua vim.lsp.buf.format{async=false}
  augroup end
]]

-- Autoformat
--
-- vim.api.nvim_create_autocmd("WinLeave", {
--   callback = function()
--     if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
--     end
--   end,
-- })

local ignore_filetypes = {
  "neo-tree",
  "neo-tree-popup",
  "notify",
  "TelescopePrompt",
  "snacks_picker_list",
  "snacks_picker_input",
  "DiffviewFiles"
}

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.focus_disable = true
    else
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})


 
    -- Auto-enter normal mode when closing terminal
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*",
      callback = function()
        -- Exit terminal mode to normal mode
        vim.cmd('stopinsert')
      end,
    })
    
    -- Save and restore cursor position
    local cursor_pos = nil
    
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        -- Save cursor position before opening terminal
        cursor_pos = vim.api.nvim_win_get_cursor(0)
      end,
    })
    
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*",
      callback = function()
        -- Restore cursor position after closing terminal
        if cursor_pos then
          vim.schedule(function()
            local ok = pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
            if not ok then
              -- If setting cursor fails, just go to normal mode
              vim.cmd('stopinsert')
            end
          end)
        end
      end,
    })
