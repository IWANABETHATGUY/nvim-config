local diffview_toggle = function()
    local lib = require('diffview.lib')
    local view = lib.get_current_view()

    if view then
        -- Diffview is open, close it
        vim.cmd('DiffviewClose')
    else
        -- Diffview is not open, open it
        vim.cmd('DiffviewOpen')
    end
end

local function trans_to_zh(kind, output)
    require("translate").translate({
        get_command = function(input)
            return {
                "trans",
                input,
                "gemini",
                kind
            }
        end,
        -- input | clipboard | selection
        input = "selection",
        -- open_float | notify | copy | insert | replace
        output = { output },
        resolve_result = function(result)
            if result.code ~= 0 then
                return nil
            end

            local ret = string.match(result.stdout, "(.*)\n")
            if kind == "wording" then
                require('notify')(ret, "info", {
                    title = "gemini wording"
                })
            end

            return ret
        end,
    })
end

-- ~/.config/nvim/lua/copy-file-line.lua

local M = {}

function M.copy_file_with_lines(opts)
  local start_line = opts.line1
  local end_line = opts.line2
  local relative_path = vim.fn.expand('%:~:.')
  
  if relative_path == '' then
    vim.notify('File not saved!', vim.log.levels.WARN)
    return
  end

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getcurpos()
  start_line = start_pos[2]
  end_line = end_pos[2]
  
  local result = string.format('%s#L%d-L%d', relative_path, start_line, end_line)
  
  vim.fn.setreg('+', result)
  
  vim.notify('Copied: ' .. result, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('NeotreeReveal', function()
    vim.cmd.Neotree('reveal')
end, {})

vim.api.nvim_create_user_command('DiffviewToggle', function()
    diffview_toggle()
end, {})

vim.api.nvim_create_user_command('DiffCompareToMain', function()
    vim.cmd('DiffviewOpen main... --imply-local')
end, {})

vim.api.nvim_create_user_command('ResetGrapple', function()
    vim.cmd('lua require("grapple").reset()')
end, {})

vim.api.nvim_create_user_command('CopyFilePathAndRange', function(opts)
  M.copy_file_with_lines(opts)
end, {
    range = true
})


vim.api.nvim_create_user_command('TranslateSelect', function()
    trans_to_zh("translate", "open_float")
end, { range = true })

vim.api.nvim_create_user_command('PolishSelect', function()
    trans_to_zh("wording", "copy")
end, { range = true })


return M
