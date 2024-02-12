local ok, terms = pcall(require, "toggleterm.terminal")
if not ok then
  return
end

M = {}

function M.run_file(c)
  if c.go_back == nil then
    c.go_back = true
  end
  local term = terms.get_or_create_term(c.num, c.dir, c.direction)
  local filetype = vim.filetype.match { filename = c.filename }
  if not term:is_open() then
    term:open(c.size, c.direction)
  end
  if filetype == "python" then
    local stat = vim.loop.fs_stat "poetry.lock"
    if stat == nil then
      term:send("python3 " .. c.filename, c.go_back)
    else
      term:send("poetry run python " .. c.filename, c.go_back)
    end
  elseif filetype == "sh" then
    term:send("bash " .. c.filename, c.go_back)
  end
end

return M
