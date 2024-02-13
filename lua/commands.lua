-- setup colorcolumn based on editorconfig
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local config = vim.b[bufnr].editorconfig
    if config == nil then
      return
    end
    local tw = config.max_line_length
    if tw == nil then
      return
    end
    vim.api.nvim_win_set_option(0, "colorcolumn", tw)
  end,
})

-- autoclose quickfix list after selection item
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = true })
  end,
})

-- better autoread on file change
-- https://github.com/neovim/neovim/issues/1936#issuecomment-309311829
vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  callback = function()
    vim.cmd "checktime" -- checktime triggers autoread
  end,
})

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#go-to-last-used-hidden-buffer-when-deleting-a-buffer
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    local api = require "nvim-tree.api"
    -- Only 1 window with nvim-tree left: we probably closed a file buffer
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      -- Required to let the close event complete. An error is thrown without this.
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last hidden buffer used before closing
        api.tree.toggle { find_file = true, focus = true }
        -- re-open nivm-tree
        api.tree.toggle { find_file = true, focus = true }
        -- nvim-tree is still the active window. Go to the previous window.
        vim.cmd "wincmd p"
      end, 0)
    end
  end,
})

-- Add new file types
vim.filetype.add {
  extension = {
    qml = "qml",
  },
}

-- Sometimes I got :Qa instead of :qa
vim.api.nvim_create_user_command("Qa", "qa", {})
