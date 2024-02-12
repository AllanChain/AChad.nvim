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
      border = "double",
      width = function(_)
        return vim.o.columns - 4
      end,
      height = function(_)
        return vim.o.lines - 5
      end,
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd "startinsert!"
      -- vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    -- function to run on closing the terminal
    on_close = function(_)
      vim.cmd "checktime" -- trigger auto reload after git operation
    end,
  }
  return instances[dir]
end

M.toggle = function ()
  M.create():toggle()
end
return M
