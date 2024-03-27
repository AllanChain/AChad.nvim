--[[======================================================
--                       Terminal
--======================================================]]
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VimEnter",
    keys = {
      {
        "<leader>gg",
        function()
          local lazygit = require "integrations.lazygit"
          if lazygit then
            lazygit.toggle()
          end
        end,
        desc = "Open Lazygit",
      },
      {
        "<leader>rf",
        function()
          local run = require "integrations.run_file"
          if not run then
            return
          end
          run.run_file {
            filename = vim.fn.expand "%",
            num = 10,
            direction = "horizontal",
            size = 10,
          }
        end,
        desc = "Run file",
      },
    },
    config = function()
      local ok, toggleterm = pcall(require, "toggleterm")
      if not ok then
        return
      end
      toggleterm.setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.env.NVIM_SHELL or vim.o.shell,
        float_opts = {
          border = "curved",
        },
      }
    end,
  },
}
