return {
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        suppress_on_insert = true,
        ignore_done_already = true,
        ignore_empty_message = true,
        display = {
          render_limit = 8,
          done_ttl = 0,
          done_icon = "",
        },
      },
    },
    config = function(_, opts)
      require("fidget").setup(opts)
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local has_alpha, alpha = pcall(require, "alpha")
      if not has_alpha then
        return
      end
      alpha.setup(require("configs.alpha").config)
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VimEnter",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    opts = {
      hi = {
        mixing_color = "#2e3440"
      },
    },
    init = function()
      vim.diagnostic.config { virtual_text = false }
    end,
  },
}
