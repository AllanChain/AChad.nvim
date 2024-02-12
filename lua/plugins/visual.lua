--[[======================================================
--                   UI and highlighting
--======================================================]]
return {
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    config = function()
      local colors = require("onenord.colors").load()
      require("onenord").setup {
        custom_highlights = {
          ["ConflictIncoming"] = colors.diff_add_bg,
          ["ConflictCurrent"] = colors.diff_change_bg,
        },
      }
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
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          "help",
          "terminal",
          "lazy",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "alpha",
          "notify",
          "",
        },
        buftypes = { "terminal" },
      },
      scope = { enabled = false },
      indent = { char = "│" },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VimEnter",
    opts = {},
  },
  {
    "folke/twilight.nvim",
    event = "BufReadPost",
  },
  {
    "folke/todo-comments.nvim", -- NOTE: fancy TODO comment
    event = "BufReadPost",
    config = function()
      local ok, comments = pcall(require, "todo-comments")
      if not ok then
        return
      end
      comments.setup {}
    end,
  },
  { -- Dim unused vars
    "zbirenbaum/neodim",
    event = "LspAttach",
    -- TODO: Remove the constrain after NeoVim 0.10.0
    commit = "f11c110",
    opts = {
      alpha = 0.5,
      blend_color = "#2e3440",
    },
    config = function(_, opts)
      require("neodim").setup(opts)
    end,
  },
  {
    "Bekaboo/deadcolumn.nvim",
    event = "BufReadPost",
  },
}
