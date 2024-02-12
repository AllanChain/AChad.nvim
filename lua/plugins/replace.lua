--[[======================================================
--                   Search and replace
--======================================================]]
return {
  { -- structural search and replace
    "cshuaimin/ssr.nvim",
    event = "BufReadPost",
  },
  { -- global search and replace
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
  },
}
