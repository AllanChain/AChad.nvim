--[[======================================================
--            Language-specific dev plugins
--======================================================]]
local github = require "github"

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local ok, neodev = pcall(require, "neodev")
      -- Neodev should be set up before lspconfig
      if ok then
        neodev.setup {
          setup_jsonls = false,
        }
      end
      require "configs.lspconfig"
    end,
    dependencies = {
      "folke/neodev.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "luacheck",
        "typescript-language-server",
        "emmet-ls",
        "eslint_d",
        "pyright",
        "shfmt",
        "shellcheck",
      },
      PATH = "skip",
      github = {
        download_url_template = github .. "%s/releases/download/%s/%s",
      },
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})
      require("mason").setup(opts)
    end,
  },
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
    "JuliaEditorSupport/julia-vim",
    lazy = false,
    ft = { "julia" },
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      render_modes = { 'n', 'v', 'i', 'c' },
      heading = {
        sign = false,
        backgrounds = { 'RenderMarkdownH2Bg' },
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
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>")
    end,
  },
}
