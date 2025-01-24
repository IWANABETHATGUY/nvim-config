local function trans_to_zh()
  require("translate").translate({
    get_command = function(input)
      return {
        "deepseek-trans",
        input,
      }
    end,
    -- input | clipboard | selection
    input = "selection",
    -- open_float | notify | copy | insert | replace
    output = { "open_float" },
    resolve_result = function(result)
      if result.code ~= 0 then
        return nil
      end

      return string.match(result.stdout, "(.*)\n")
    end,
  })
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


vim.api.nvim_create_user_command('JumpToParentContext', function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, {})


vim.api.nvim_create_user_command('TranslateSelect', function()
  trans_to_zh()
end, { range = true })


diffview_toggle = function()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    -- Current tabpage is a Diffview; close it
    vim.cmd.DiffviewClose()
  else
    -- No open Diffview exists: open a new one
    vim.cmd.DiffviewOpen()
  end
end
