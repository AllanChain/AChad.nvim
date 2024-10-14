return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    command = { "Neotree" },
    branch = "v3.x",
    keys = {
      { "<C-n>", "<cmd> Neotree toggle <CR>", desc = "Toggle tree" },
      { "<leader>e", "<cmd> Neotree focus <CR>", desc = "Focus tree" },
    },
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        follow_current_file = {
          enabled = true
        }
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  },
}
