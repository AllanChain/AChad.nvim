local is_inside_work_tree = {}

local project_files = function()
  local opts = {}

  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    require("telescope.builtin").git_files(opts)
  else
    require("telescope.builtin").find_files(opts)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    ft = { "alpha" },
    dependencies = { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" },
    keys = {
      {
        "<leader>ff",
        project_files,
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
}
