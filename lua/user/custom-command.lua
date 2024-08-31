
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
