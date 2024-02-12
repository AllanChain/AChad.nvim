return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<C-n>", "<cmd> NvimTreeToggle <CR>", desc = "Toggle tree" },
      { "<leader>e", "<cmd> NvimTreeFocus <CR>", desc = "Focus tree" },
    },
    opts = {
      filters = {
        dotfiles = false,
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = false,
        side = "left",
        width = 30,
        preserve_window_proportions = true,
      },
      git = {
        enable = false,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = false,
        highlight_opened_files = "none",
        indent_markers = {
          enable = false,
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
          glyphs = {
            default = "󰈚",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      git = {
        enable = true,
        ignore = true,
      },
    },
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    ft = { "alpha" },
    dependencies = { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fw",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find words",
      },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Find diagnostic",
      },
      {
        "<leader>fp",
        function()
          require("telescope").extensions.projects.projects()
        end,
        desc = "Find projects",
      },
      {
        "<leader>fu",
        function()
          require("telescope").extensions.undo.undo()
        end,
        desc = "Undo history",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files {
            no_ignore = true,
            hidden = true,
            file_ignore_patterns = {
              "node_modules/",
              "__pycache__/",
            },
          }
        end,
        "Find files (no ignore)",
      },
    },
    opts = function()
      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
            i = {
              ["<C-Up>"] = function(bufnr)
                require("telescope.actions").cycle_history_prev(bufnr)
              end,
              ["<C-Down>"] = function(bufnr)
                require("telescope.actions").cycle_history_next(bufnr)
              end,
            },
          },
        },
        extensions_list = { "themes", "projects", "undo" },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup { options = { theme = "onenord" } }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
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
      local colors = require("onenord.colors").load()
      local bar_bg = colors.bg
      local bar_bg_selected = colors.diff_change_bg
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
          fill = { bg = bar_bg_selected },
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
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    -- init = function()
    --   require("core.utils").load_mappings "whichkey"
    -- end,
    cmd = "WhichKey",
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}
