local map = vim.keymap.set

map("n", "<C-s>", function()
  vim.cmd "write"
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == "texlab" then
      vim.cmd "TexlabBuild"
    end
  end
end)
map("i", "<C-e>", "<End>")
map("n", "<Esc>", "<cmd> nohl <CR>")
map("n", "ZZ", "<cmd> xa <CR>")
