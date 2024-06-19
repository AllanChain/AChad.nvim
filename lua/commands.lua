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

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.env.TMUX and vim.v.event.operator == "y" and vim.v.event.regname == "" then
      require("vim.ui.clipboard.osc52").copy "+"(vim.v.event.regcontents)
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
