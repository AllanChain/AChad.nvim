return {
  {
    "mfussenegger/nvim-dap",
    event = "BufReadPost",
    keys = {
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP continue",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP breakpoint",
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          local ui_ok, dapui = pcall(require, "dapui")
          local dap_ok, dap = pcall(require, "dap")
          if not ui_ok and dap_ok then
            return
          end
          vim.fn.sign_define("DapBreakpoint", {
            text = "",
            texthl = "DiagnosticSignError",
            linehl = "",
            numhl = "",
          })
          dapui.setup {}
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          local ok, dap_text = pcall(require, "nvim-dap-virtual-text")
          if not ok then
            return
          end
          dap_text.setup {}
        end,
      },
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          local ok, dap_python = pcall(require, "dap-python")
          if not ok then
            return
          end
          dap_python.setup()
        end,
      },
      {
        "leoluz/nvim-dap-go",
        config = function()
          require("dap-go").setup()
        end,
      },
    },
  },
}
