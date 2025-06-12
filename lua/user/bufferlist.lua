require('bufferlist').setup {
    keymap = {
        close_buf_prefix = "c",
        force_close_buf_prefix = "f",
        save_buf = "s",
        visual_close = "d",
        visual_force_close = "f",
        visual_save = "s",
        multi_close_buf = "m",
        multi_save_buf = "w",
        save_all_unsaved = "a",
        close_all_saved = "d0",
        toggle_path = "p",
        close_bufferlist = "q",
    },
    win_keymaps = {
        {
            "<cr>",
            function(opts)
                local curpos = vim.fn.line(".")
                vim.cmd("bwipeout | buffer " .. opts.buffers[curpos])
            end,
            { desc = "BufferList: my description" },
        },
    }, -- add keymaps to the BufferList window
    bufs_keymaps = {
    },
    width = 100,
    icons = {
        prompt = "", -- for multi_{close,save}_buf prompt
        save_prompt = "󰆓 ",
        line = "▎",
        modified = "󰝥",
    },
    top_prompt = true, -- set this to false if you want the prompt to be at the bottom of the window instead of on top of it.
    show_path = true,  -- show the relative paths the first time BufferList window is opened}
}
