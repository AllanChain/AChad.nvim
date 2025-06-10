return {
  on_attach = function(client, bufnr)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        { "gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Source/header" },
      }, { bufnr = bufnr })
    end
  end,
}
