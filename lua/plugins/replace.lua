--[[======================================================
--                   Search and replace
--======================================================]]
return {
  { -- structural search and replace
    "cshuaimin/ssr.nvim",
    event = "BufReadPost",
  },
  { -- global search and replace
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup {
      }
    end,
  },
}
