-- lua/plugins/themery.lua
return {
  "zaldih/themery.nvim",
  lazy = false, -- or true if you want to load it lazily
  config = function()
    require("themery").setup({
      themes = {
        "tokyonight-night",
        "tokyonight-storm",
        "catppuccin-mocha",
        "moonfly",
        -- add any colorscheme you have installed
      },
      livePreview = true,
    })
  end,
}
