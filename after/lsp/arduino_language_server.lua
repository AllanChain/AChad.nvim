return {
  on_new_config = function(config, root_dir)
    config.capabilities.textDocument.semanticTokens = vim.NIL
    config.capabilities.workspace.semanticTokens = vim.NIL
  end,
}
