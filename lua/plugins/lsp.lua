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
    config = function()
      local lspconfig = require "lspconfig"
      local ok, cmp_nvim_lsp = pcall(require "cmp_nvim_lsp")
      local capabilities
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      else
        capabilities = {}
      end

      require("mason-lspconfig").setup {
        handlers = {
          function(server_name) -- default handler
            require("lspconfig")[server_name].setup { capabilities = capabilities }
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = { diagnostics = { globals = { "vim" } } },
              },
            }
          end,
          clangd = function()
            lspconfig.clangd.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                local wk_ok, wk = pcall(require, "which-key")
                if wk_ok then
                  wk.add({
                    { "gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Source/header" },
                  }, { bufnr = bufnr })
                end
              end,
            }
          end,
          arduino_language_server = function()
            lspconfig.arduino_language_server.setup {
              capabilities = capabilities,
              on_new_config = function(config, root_dir)
                config.capabilities.textDocument.semanticTokens = vim.NIL
                config.capabilities.workspace.semanticTokens = vim.NIL
              end,
            }
          end,
          ts_ls = function()
            lspconfig.ts_ls.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                client.server_capabilities.document_formatting = false
              end,
            }
          end,
          pyright = function()
            lspconfig.pyright.setup {
              capabilities = capabilities,
              settings = {
                python = { analysis = { typeCheckingMode = "off" } },
              },
            }
          end,
          ruff = function()
            lspconfig.ruff.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if client.name == "ruff" then
                  -- Disable hover in favor of Pyright
                  client.server_capabilities.hoverProvider = false
                end
              end,
            }
          end,
          julials = function()
            lspconfig.julials.setup {
              capabilities = capabilities,
              settings = {
                julia = { lint = { missingrefs = "none" } },
              },
            }
          end,
          texlab = function()
            lspconfig.texlab.setup {
              capabilities = capabilities,
              settings = {
                texlab = { build = { args = { "-interaction=nonstopmode", "%f" } } },
              },
            }
          end,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
      { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
      { "<leader>do", vim.diagnostic.open_float, desc = "open diagnostic" },
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
