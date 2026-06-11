--[[======================================================
--           Powerful motions and actions
--======================================================]]
return {
  { -- easy change surroundings
    "kylechui/nvim-surround",
    event = "VeryLazy",
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim", -- s{char1}{char2} fast navigation
    event = "BufReadPost",
    config = function()
      local ok, leap = pcall(require, "leap")
      if not ok then
        return
      end
      leap.add_default_mappings(true)
    end,
  },
}
