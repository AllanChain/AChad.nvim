local wk = require "which-key"
local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

local path = util.path
local exepath = util.exepath

-- Global mappings.
wk.add {
  { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
  { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
  { "<leader>do", vim.diagnostic.open_float, desc = "open diagnostic" },
  { "<leader>de", vim.diagnostic.enable, desc = "enable diagnostic" },
  {
    "<leader>dd",
    function()
      vim.diagnostic.enable(false)
    end,
    desc = "disable diagnostic",
  },
}

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
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

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- Setup language servers.
local function setup(lsp, opts)
  local executable = lspconfig[lsp].document_config.default_config.cmd[1]
  opts = vim.tbl_extend("force", { capabilities = capabilities }, opts or {})
  if vim.fn.executable(executable) ~= 0 then
    lspconfig[lsp].setup(opts)
  end
end

setup "html"
setup "cssls"
setup "astro"
setup "volar"
setup "svelte"
setup "eslint"
setup "jsonls"
setup "emmet_ls"
setup "gopls"
setup "tinymist"

setup("clangd", {
  on_attach = function(client, bufnr)
    wk.add({
      { "gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Source/header" },
    }, { bufnr = bufnr })
  end,
})

setup("arduino_language_server", {
  on_new_config = function(config, root_dir)
    config.capabilities.textDocument.semanticTokens = vim.NIL
    config.capabilities.workspace.semanticTokens = vim.NIL
  end,
})

setup("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

setup("tsserver", {
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
  end,
})

setup("pyright", {
  settings = {
    python = { analysis = { typeCheckingMode = "off" } },
  },
})

setup("ruff_lsp", {
  on_attach = function(client, bufnr)
    if client.name == "ruff_lsp" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
})

setup("julials", {
  settings = {
    julia = { lint = { missingrefs = "none" } },
  },
})

setup("texlab", {
  settings = {
    texlab = {
      build = { args = { "-interaction=nonstopmode", "%f" } },
    },
  },
})
