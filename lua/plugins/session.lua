--[[======================================================
--            Managing sessions and projects
--======================================================]]
return {
  {
    "tiagovla/scope.nvim",
    event = "VimEnter",
    config = function()
      require("scope").setup {}
    end,
  },
  {
    "ahmedkhalf/project.nvim", -- auto cd into project root
    lazy = false,
    opts = {
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git" },
      scope_chdir = "tab",
      silent_chdir = false,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
  {
    "okuuva/auto-save.nvim", -- auto save
    -- using the fork until https://github.com/Pocco81/auto-save.nvim/pull/67
    event = "BufReadPost",
    config = function()
      local ok, autosave = pcall(require, "auto-save")
      if not ok then
        return
      end
      local utils = require "auto-save.utils.data"
      autosave.setup {
        debounce_delay = 5000,
        condition = function(buf)
          if vim.fn.getcwd():match "nvim" then
            return false
          end
          if
            vim.fn.getbufvar(buf, "&modifiable") == 1
            and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), { "TelescopePrompt", "alpha" })
          then
            return true
          end
          return false
        end,
      }
    end,
  },
}
