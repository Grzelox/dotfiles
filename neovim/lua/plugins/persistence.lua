return {
  "folke/persistence.nvim",
  -- load after a file is read, so we are out of BufReadPre
  event = "BufReadPost",
  opts = {
    options = { "buffers", "curdir", "tabpages", "winsize" },
  },
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    -- Auto-load last session when starting *without* file args
    -- and when we're not inside a special buffer (like Lazy, Mason etc.)
    if vim.fn.argc(-1) == 0 then
      -- defer to next tick so we're out of autocommand context
      vim.schedule(function()
        persistence.load()
      end)
    end
  end,
}
