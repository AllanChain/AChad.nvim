return {
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
  end,
}
