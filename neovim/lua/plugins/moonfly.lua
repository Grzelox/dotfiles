-- lua/plugins/moonfly.lua
return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false, -- load at startup so Themery can switch immediately
  priority = 1000, -- load before other UI plugins
  config = function()
    -- optional: set Moonfly as your default colorscheme
    vim.cmd("colorscheme moonfly")
  end,
}
