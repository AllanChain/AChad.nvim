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
    cmd = { "Mason", "MasonInstall" },
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
      github = {
        download_url_template = github .. "%s/releases/download/%s/%s",
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPost",
    config = function()
      require "configs.null-ls"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    tag = "v0.9.2",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "python",
        "javascript",
        "css",
        "html",
        "bash",
        "markdown",
        "markdown_inline",
        "regex",
      },
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
    "JuliaEditorSupport/julia-vim",
    lazy = false,
    ft = { "julia" },
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
