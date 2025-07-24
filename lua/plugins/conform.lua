---@class (exact) Pattern
---@field read string
---@field find? string

---Match pattern
---@param root string
---@param pattern Pattern
local function match_pattern(root, pattern)
  if type(pattern) == "function" then
    return pattern(root)
  elseif type(pattern) == "table" then
    if #pattern > 0 then -- pattern is an array
      for _, v in ipairs(pattern) do
        if match_pattern(root, v) then
          return true
        end
      end
      return false
    else
      if pattern.read == nil then -- Should read something
        return false
      end
      local f = io.open(root .. "/" .. pattern.read, "r")
      if f == nil then -- File not exists
        return false
      end
      if pattern.find == nil then -- No need to find anything
        return true
      end
      for line in f:lines() do
        if line:match(pattern.find) then
          return true
        end
      end
      return false
    end
  end
end

---Test if formatter is available
---@param formatters string | table<string>
---@param pattern Pattern
---@param bufnr integer
---@return boolean
local function available(formatters, pattern, bufnr)
  local conform = require "conform"
  local info
  if type(formatters) == "table" then
    for _, formatter in ipairs(formatters) do
      info = conform.get_formatter_info(formatter, bufnr)
      if info.available then
        break
      end
    end
  else
    info = conform.get_formatter_info(formatters, bufnr)
  end
  if info.available then
    local cwd = info.cwd or vim.fn.getcwd()
    if match_pattern(cwd, pattern) then
      return true
    end
  end
  return false
end

local function with(formatter, pattern, bufnr)
  return available(formatter, pattern, bufnr) and formatter or nil
end

---Remove nil in formatters
local function expand_formatters(tbl)
  local result = {}
  for i = 1, #tbl do
    if tbl[i] ~= nil then
      table.insert(result, tbl[i])
    end
  end
  return result
end

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format { async = true }
        end,
        desc = "Format file",
      },
    },
    opts = function()
      local function python_formatters(bufnr)
        local formatters = expand_formatters {
          with("ruff_fix", {
            { read = "pyproject.toml", find = "ruff" },
          }, bufnr),
          with("ruff_format", {
            { read = "pyproject.toml", find = "ruff" },
          }, bufnr),
          with("black", {
            { read = "pyproject.toml", find = "black" },
          }, bufnr),
          with("isort", {
            { read = "pyproject.toml", find = "isort" },
          }, bufnr),
        }
        if next(formatters) == nil then
          table.insert(formatters, "ruff_format")
        end
        return formatters
      end
      local function js_formatters(bufnr)
        return expand_formatters {
          with("eslint_d", {
            { read = "package.json", find = "eslint" },
          }, bufnr),
          with("prettier", {
            { read = "package.json", find = "prettier" },
          }, bufnr),
        }
      end
      local formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        python = python_formatters,
      }
      for _, lang in ipairs { "arduino", "c", "cpp" } do
        formatters_by_ft[lang] = { "clang-format" }
      end
      for _, lang in ipairs { "bash", "zsh", "sh" } do
        formatters_by_ft[lang] = { "shfmt" }
      end
      for _, lang in ipairs { "html", "css", "scss", "javascript", "typescript", "astro", "svelte", "vue" } do
        formatters_by_ft[lang] = js_formatters
      end
      return {
        formatters_by_ft = formatters_by_ft,
      }
    end,
  },
}
