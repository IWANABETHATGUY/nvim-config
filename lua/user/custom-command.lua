
local diffview_toggle = function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd('DiffviewOpen')
    else
      vim.cmd('DiffviewClose')
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
  trans_to_zh("translate", "open_float")
end, { range = true })

vim.api.nvim_create_user_command('PolishSelect', function()
  trans_to_zh("wording", "copy")
end, { range = true })

