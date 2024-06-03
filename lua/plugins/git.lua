--[[======================================================
--               Git and version control
--======================================================]]
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>go", "<Cmd>DiffviewOpen<CR>", desc = "Open diffview" },
      { "<leader>gh", "<Cmd>DiffviewFileHistory<CR>", desc = "Open file history" },
    },
    config = true,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPost",
    keys = {
      { "<leader>co", "<Plug>(git-conflict-ours)", desc = "Use ours" },
      { "<leader>ct", "<Plug>(git-conflict-theirs)", desc = "Use theirs" },
      { "<leader>cb", "<Plug>(git-conflict-both)", desc = "Use both" },
      { "<leader>cn", "<Plug>(git-conflict-none)", desc = "Use none" },
      { "[x", "<Plug>(git-conflict-prev-conflict)", desc = "Prev conflict" },
      { "]x", "<Plug>(git-conflict-next-conflict)", desc = "Next conflict" },
    },
    opts = {
      default_mappings = false,
      disable_diagnostics = true,
      highlights = {
        incoming = "ConflictIncoming",
        current = "ConflictCurrent",
      },
    },
    config = function(_, opts)
      local ok, gc = pcall(require, "git-conflict")
      if not ok then
        return
      end
      gc.setup(opts)
    end,
  },
}
