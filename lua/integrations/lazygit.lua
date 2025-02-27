local ok, terminal = pcall(require, "toggleterm.terminal")
if not ok then
  return nil
end

local Terminal = terminal.Terminal

local M = {}

local instances = {}

M.create = function()
  local dir = vim.fn.getcwd(0, 0)
  if instances[dir] ~= nil then
    return instances[dir]
  end
  instances[dir] = Terminal:new {
    cmd = "lazygit",
    dir = dir,
    direction = "float",
    float_opts = {
      border = "none",
      width = function(_)
        return vim.o.columns
      end,
      height = function(_)
        return vim.o.lines
      end,
    },
    -- function to run on closing the terminal
    on_close = function(_)
      vim.cmd "checktime" -- trigger auto reload after git operation
    end,
  }
  return instances[dir]
end

M.toggle = function()
  M.create():toggle()
end
return M
