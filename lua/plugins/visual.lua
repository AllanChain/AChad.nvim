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
        fade_nc = true, -- Fade non-current windows
        custom_highlights = {
          ["DiffDelete"] = { fg = colors.diff_change_bg, bg = colors.none },
          ["ConflictIncoming"] = colors.diff_add_bg,
          ["ConflictCurrent"] = colors.diff_change_bg,
        },
      }
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
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        names = false,
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
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
  { -- Highlight command line
    {
      "Sam-programs/cmdline-hl.nvim",
      event = "VimEnter",
      opts = {
        custom_types = {
          ["lua"] = { icon = " " },
        },
      },
    },
  },
}
