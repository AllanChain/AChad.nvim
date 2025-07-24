return {
  on_attach = function(client, bufnr)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        {
          "gh",
          function()
            local method_name = "textDocument/switchSourceHeader"
            if not client then
              return vim.notify(
                ("method %s is not supported by any servers active on the current buffer"):format(method_name)
              )
            end
            local params = vim.lsp.util.make_text_document_params(bufnr)
            client.request(method_name, params, function(err, result)
              if err then
                error(tostring(err))
              end
              if not result then
                vim.notify "corresponding file cannot be determined"
                return
              end
              vim.cmd.edit(vim.uri_to_fname(result))
            end, bufnr)
          end,
          desc = "Source/header",
        },
      }, { bufnr = bufnr })
    end
  end,
}
