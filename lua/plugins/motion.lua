--[[======================================================
--           Powerful motions and actions
--======================================================]]
return {
  { -- easy change surroundings
    "tpope/vim-surround",
    event = "BufReadPost",
  },
  {
    "ggandor/leap.nvim", -- s{char1}{char2} fast navigation
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
