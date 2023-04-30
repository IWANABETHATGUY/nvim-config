local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")

return require("telescope").register_extension {
  exports = {
    restart_ls = function(opts)
      opts = opts or {}

      local make_finder = function()
        local res = {}
        local original_bufnr = vim.api.nvim_get_current_buf()
        local buf_clients = vim.lsp.get_active_clients { bufnr = original_bufnr }
        for _, client in pairs(buf_clients) do
          table.insert(res, client.name)
        end
        return finders.new_table({
          results = res
        })
      end
      pickers.new(opts, {
        prompt_title = 'Restart language server',
        finder = make_finder(),
        -- finder = finders.new_dynamic(function()
        --   return finders.new_table({
        --     results = {
        --       'red',
        --       'blue',
        --       'green'
        --     }
        --   })
        -- end),
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()

            if selection ~= nil then
              local server_id = selection[1]
              vim.cmd(string.format("LspRestart %s", server_id))
            end
          end)
          return true
        end,
      }):find()
    end
  }
}
