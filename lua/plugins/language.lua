--[[======================================================
--            Language-specific dev plugins
--======================================================]]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VimEnter" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      -- use yati indent instead of the original one
      yati = {
        enable = true,
      },
      indent = {
        enable = false,
      },
      matchup = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      local lint = require "lint"
      lint.linters.pydoclint = {
        name = "pydoclint",
        cmd = "pydoclint",
        stdin = false,
        stream = "stderr",
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern("(%d+): (.*)", { "lnum", "message" }),
      }
      local linters_by_ft = {
        python = { "mypy", "flake8", "pydoclint" },
        cpp = { "clazy" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          local linters = linters_by_ft[vim.bo.filetype] or {}
          if vim.fn.expand("%:p"):match ".github/workflows/" then
            table.insert(linters, "actionlint")
          end
          local available_linters = {}
          for _, linter in ipairs(linters) do
            if vim.fn.executable(linter) ~= 0 then
              table.insert(available_linters, linter)
            end
          end
          lint.try_lint(available_linters)
        end,
      })
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      render_modes = { "n", "v", "i", "c" },
      heading = {
        sign = false,
        backgrounds = { "RenderMarkdownH2Bg" },
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
  {
    "stevearc/aerial.nvim",
    event = "BufReadPost",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup {
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      }
      -- use AerialToggle! to retain cursor focus
      vim.keymap.set("n", "<leader>az", "<cmd>AerialToggle<CR>")
    end,
  },
}
