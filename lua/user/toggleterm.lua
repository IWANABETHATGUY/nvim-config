local buffer_sizes = {}

require("toggleterm").setup {
    size = function(term)
        if term.direction == "horizontal" then
            return 20
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,

    on_open = function(term)
        buffer_sizes[term.id] = 20
        vim.keymap.set('t', '<C-e>', [[<Cmd>lua _G.toggle_fullscreen_term()<CR>]], {
            buffer = term.bufnr,
            noremap = true,
            silent = true,
            desc = "Toggle fullscreen terminal"
        })
        vim.keymap.set('n', '<C-e>', [[<Cmd>lua _G.toggle_fullscreen_term()<CR>]], {
            buffer = term.bufnr,
            noremap = true,
            silent = true,
            desc = "Toggle fullscreen terminal"
        })
    end,
    -- function to run on closing the terminal
    on_close = function(term)
    end,
    -- start_in_insert = true,
    persist_mode = true,
}

-- -- Example keybindings
vim.keymap.set('n', '<c-\\>', '<CMD>ToggleTerm<CR>')
vim.keymap.set('t', '<c-\\>', '<C-\\><C-n><CMD>ToggleTerm<CR>')
--
--
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

function _G.toggle_fullscreen_term()
    local term = require('toggleterm.terminal')
    local termid = term.get_focused_id()
    if termid ~= 0 then
        local cur_term = term.get(termid)
        if buffer_sizes[termid] == 20 then
            cur_term:close()
            cur_term:open(40, 'horizontal')
            buffer_sizes[termid] = 40;
        else
            cur_term:close()
            cur_term:open(20, 'horizontal')
            buffer_sizes[termid] = 20
        end
    end
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
