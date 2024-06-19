--[[======================================================
--            Things a vanilla IDE should have
--======================================================]]
return {
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      --Config goes here
    },
  },
  { -- auto adjust shiftwidth
    "tpope/vim-sleuth",
    event = "BufReadPost",
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_enabled = false
    end,
  },
  {
    "ethanholz/nvim-lastplace", -- remember cursor positions
    event = "BufReadPost",
    config = function()
      local ok, lastplace = pcall(require, "nvim-lastplace")
      if not ok then
        return
      end
      lastplace.setup {}
    end,
  },
  {
    "h-hg/fcitx.nvim",
    event = "BufReadPost",
  },
  {
    "yioneko/nvim-yati", -- better indent than treesitter
    event = "BufReadPost",
  },
}
