local map = vim.keymap.set

map("n", "<C-s>", function()
  vim.cmd "write"
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == "texlab" then
      vim.cmd "TexlabBuild"
    end
  end
end)
map("i", "<C-e>", "<End>")
map("n", "<Esc>", "<cmd> nohl <CR>")
map("n", "ZZ", "<cmd> xa <CR>")
-- Allow using <C-I> separately from <Tab>
map("n", "<C-I>", "<C-I>", { noremap = true })

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local ok, wk = pcall(require, "which-key")
    if not ok then
      return
    end
    wk.add({
      { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
      { "gd", vim.lsp.buf.definition, desc = "Goto declaration" },
      { "<leader>D", vim.lsp.buf.type_definition, desc = "Goto type" },
      { "gr", vim.lsp.buf.references, desc = "Goto references" },
      { "K", vim.lsp.buf.hover, desc = "Hover hint" },
      { "gi", vim.lsp.buf.implementation, desc = "Goto implementation" },
      { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature" },
      { "<leader>ra", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
    }, { buffer = ev.buf })
  end,
})
