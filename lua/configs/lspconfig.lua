local wk = require "which-key"
local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

local path = util.path
local exepath = util.exepath

-- Global mappings.
wk.register {
  ["[d"] = { vim.diagnostic.goto_prev, "Prev diagnostic" },
  ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
  ["<leader>do"] = { vim.diagnostic.open_float, "open diagnostic" },
  ["<leader>dd"] = { vim.diagnostic.disable, "disable diagnostic" },
  ["<leader>de"] = { vim.diagnostic.enable, "enable diagnostic" },
}

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    wk.register({
      ["gD"] = { vim.lsp.buf.declaration, "Goto declaration" },
      ["gd"] = { vim.lsp.buf.definition, "Goto declaration" },
      ["<leader>D"] = { vim.lsp.buf.type_definition, "Goto type" },
      ["gr"] = { vim.lsp.buf.references, "Goto references" },
      ["K"] = { vim.lsp.buf.hover, "Hover hint" },
      ["gi"] = { vim.lsp.buf.implementation, "Goto implementation" },
      ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature" },
      ["<leader>ra"] = { vim.lsp.buf.rename, "Rename" },
      ["<leader>fm"] = { vim.lsp.buf.format, "Format" },
      ["<leader>ca"] = { vim.lsp.buf.code_action, "Code action" },
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
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
}

local servers = {
  "html",
  "cssls",
  "julials",
  "astro",
  "volar",
  "svelte",
  "jsonls",
  "emmet_ls",
  "gopls",
  "clangd",
}

for _, lsp in ipairs(servers) do
  local executable = lspconfig[lsp].document_config.default_config.cmd[1]
  if vim.fn.executable(executable) ~= 0 then
    lspconfig[lsp].setup {
      capabilities = capabilities,
    }
  end
end

lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
  end,
}

-- https://github.com/neovim/nvim-lspconfig/issues/500
local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  -- Find and use virtualenv via poetry in workspace directory.
  local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
    return path.join(venv, "bin", "python")
  end
  -- Fallback to system Python.
  return exepath "python3" or exepath "python" or "python"
end

lspconfig.pyright.setup {
  capabilities = capabilities,
  before_init = function(_, config)
    config.settings.python.pythonPath = get_python_path(config.root_dir)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}

lspconfig.julials.setup {
  capabilities = capabilities,
  settings = {
    julia = {
      lint = {
        missingrefs = "none",
      },
    },
  },
}

lspconfig.texlab.setup {
  capabilities = capabilities,
  settings = {
    texlab = {
      build = {
        onSave = true,
        args = { "-interaction=nonstopmode", "%f" },
      },
    },
  },
}
