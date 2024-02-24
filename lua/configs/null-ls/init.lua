local ok, null_ls = pcall(require, "null-ls")

if not ok then
  return
end

local utils = require "null-ls.utils"

local julia = require "configs.null-ls.julia"

local b = null_ls.builtins

local cond_cache = {}

local function find_root()
  local fname = vim.api.nvim_buf_get_name(0)
  require("null-ls.config").get().root_dir(fname)
end

local function match_pattern(root, pattern)
  if type(pattern) == "function" then
    return pattern(root)
  elseif type(pattern) == "string" then
    return utils.make_conditional_utils().root_has_file_matches(pattern)
  elseif type(pattern) == "table" then
    if #pattern > 0 then -- pattern is an array
      for _, v in ipairs(pattern) do
        if match_pattern(root, v) then
          return true
        end
      end
      return false
    else
      if pattern.read == nil or pattern.find == nil then
        return false
      end
      local f = io.open(root .. "/" .. pattern.read, "r")
      if f == nil then
        return false
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
local function create_run_condition(name, pattern)
  return function(params)
    -- NOTE: params.root is not applicable because null-ls never chdir.
    -- We need to determine the correct root based on current file.
    local root = find_root()
    if root == nil then
      root = vim.loop.cwd()
    end
    if root == nil then
      return
    end
    if cond_cache[root] == nil then
      cond_cache[root] = {}
    end
    if cond_cache[root][name] ~= nil then
      return cond_cache[root][name]
    end
    local enabled = match_pattern(root, pattern)
    cond_cache[root][name] = enabled
    return enabled
  end
end

local sources = {
  --[[#########################
  --           Python
  --#########################]]
  b.diagnostics.mypy.with {
    runtime_condition = create_run_condition("mypy", {
      ".mypy.ini",
      { read = "pyproject.toml", find = "%[tool.mypy%]" },
      { read = "setup.cfg", find = "mypy" },
    }),
  },
  --[[#########################
  --            Lua
  --#########################]]
  b.diagnostics.luacheck.with { extra_args = { "--global vim" } },
  --[[#########################
  --          Golang
  --#########################]]
  b.diagnostics.staticcheck,
  --[[#########################
  --       Miscellaneous
  --#########################]]
  b.diagnostics.shellcheck,
  julia,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
