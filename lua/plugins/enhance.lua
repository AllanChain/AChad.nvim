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
    "numToStr/Comment.nvim",
    lazy = true,
    keys = {
      {
        "<leader>/",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        mode = "v",
        desc = "Comment",
      },
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Comment",
      },
    },
    config = function()
      require("Comment").setup()
    end,
  },
  { -- auto adjust shiftwidth
    "tpope/vim-sleuth",
    event = "BufReadPost",
  },
  {
    "ojroques/nvim-osc52", -- yank contents over SSH
    event = "BufReadPost",
    config = function()
      local ok, osc52 = pcall(require, "osc52")
      if not ok then
        return
      end
      osc52.setup { silent = true }
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.env.TMUX and vim.v.event.operator == "y" and vim.v.event.regname == "" then
            osc52.copy_register "+"
          end
        end,
      })
    end,
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
