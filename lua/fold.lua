local M = {}

M.foldexpr = function(lnum)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  if ft == "python" then
    return vim.treesitter.foldexpr(lnum)
  else
    return "0"
  end
end

return M
