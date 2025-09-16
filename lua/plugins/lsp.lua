--[[======================================================
--            Language-server configurations
--======================================================]]
local github = require "github"

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = {
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
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    config = function()
      local lspconfig = require "lspconfig"
      local ok, cmp_nvim_lsp = pcall(require "cmp_nvim_lsp")
      local capabilities
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      else
        capabilities = {}
      end
      vim.lsp.config("*", { capabilities = capabilities })

      require("mason-lspconfig").setup {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    keys = {
      { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
      { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
      { "<leader>dv", vim.diagnostic.open_float, desc = "open diagnostic" },
      { "<leader>de", vim.diagnostic.enable, desc = "enable diagnostic" },
      {
        "<leader>dd",
        function()
          vim.diagnostic.enable(false)
        end,
        desc = "disable diagnostic",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
  },
}
