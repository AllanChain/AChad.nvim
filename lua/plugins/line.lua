return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local function LSP_status()
        local client_names = {}
        local client_count = 0
        if rawget(vim, "lsp") then
          for _, client in ipairs(vim.lsp.get_clients()) do
            if client.attached_buffers[vim.api.nvim_get_current_buf()] then
              client_count = client_count + 1
              local client_name = client.name:gsub("[_-]lsp?$", "")
              client_name = client_name:gsub("[_-]language[_-]server$", "")
              client_names[client_count] = client_name
              if client_count == 3 then
                break
              end
            end
          end
        end
        if client_count == 0 then
          return ""
        end
        if vim.o.columns <= 100 then
          return " 󰚔 "
        end
        return "󰚔 " .. table.concat(client_names, "|")
      end
      return {
        options = {
          theme = "onenord",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diagnostics",
              symbols = { error = "E", warn = "W", info = "I", hint = "H" },
            },
          },
          lualine_c = { "filename" },
          lualine_x = { "filetype" },
          lualine_y = { LSP_status },
          lualine_z = { "location" },
        },
        extensions = { "toggleterm", "nvim-tree", "lazy", "aerial", "nvim-dap-ui" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
    keys = {
      { "<Tab>", "<cmd> BufferLineCycleNext <CR>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>", desc = "Prev buffer" },
      { "<C-q>", "<cmd> bd <CR>", desc = "Close buffer" },
      {
        "<leader>x",
        function()
          local bufferline = require "bufferline"
          local bufnr = vim.api.nvim_get_current_buf()
          bufferline.cycle(1)
          bufferline.unpin_and_close(bufnr)
        end,
        desc = "Close buffer",
      },
    },
    config = function()
      local bar_bg = { attribute = "bg", highlight = "PMenu" }
      local bar_bg_selected = { attribute = "bg", highlight = "DiffChange" }
      require("bufferline.tabpages").get = require("configs.tabpages").get
      require("bufferline").setup {
        options = {
          separator_style = "slope",
          modified_icon = "",
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", highlight = "StatusLine", separator = "  " },
            { filetype = "aerial", text = "Aerial", highlight = "StatusLine", separator = true },
          },
        },
        highlights = {
          fill = { bg = bar_bg },
          buffer_selected = { bg = bar_bg_selected },
          tab_selected = { bg = bar_bg_selected },
          close_button_selected = { bg = bar_bg_selected },
          modified_selected = { bg = bar_bg_selected },
          duplicate_selected = { bg = bar_bg_selected },
          tab_separator_selected = { fg = bar_bg, bg = bar_bg_selected },
          tab_separator = { fg = bar_bg },
          separator_selected = { fg = bar_bg, bg = bar_bg_selected },
          separator_visible = { fg = bar_bg },
          separator = { fg = bar_bg },
          offset_separator = { bg = bar_bg },
        },
      }
    end,
  },
}
