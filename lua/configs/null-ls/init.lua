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
  b.formatting.isort.with {
    runtime_condition = create_run_condition("isort", {
      ".isort.cfg",
      { read = "pyproject.toml", find = "%[tool.isort%]" },
      { read = "setup.cfg", find = "isort" },
    }),
  },
  b.formatting.black.with {
    runtime_condition = create_run_condition("black", {
      { read = "pyproject.toml", find = "%[tool.black%]" },
      { read = "setup.cfg", find = "black" },
    }),
  },
  b.diagnostics.mypy.with {
    runtime_condition = create_run_condition("mypy", {
      ".mypy.ini",
      { read = "pyproject.toml", find = "%[tool.mypy%]" },
      { read = "setup.cfg", find = "mypy" },
    }),
  },
  b.diagnostics.flake8.with {
    runtime_condition = create_run_condition("flake8", {
      ".flake8",
      { read = "setup.cfg", find = "flake8" },
    }),
  },
  b.diagnostics.pydocstyle.with {
    runtime_condition = create_run_condition("pydocstyle", {
      ".pydocstyle",
      { read = "pyproject.toml", find = "%[tool.pydocstyle%]" },
      { read = "setup.cfg", find = "pycodestyle" },
    }),
  },
  b.diagnostics.ruff.with {
    runtime_condition = create_run_condition("ruff", {
      { read = "pyproject.toml", find = "%[tool.ruff%]" },
    }),
  },
  b.formatting.autopep8.with {
    runtime_condition = function(params)
      local root = params.root or utils.get_root()
      return not cond_cache[root].black
    end,
  },
  --[[#########################
  --     JS, HTML, and CSS
  --#########################]]
  b.formatting.prettier.with {
    generator_opts = {
      prefer_local = "node_modules/.bin",
    },
    runtime_condition = create_run_condition("prettier", {
      ".prettierrc",
      { read = "package.json", find = '"prettier"' },
    }),
  },
  b.formatting.eslint_d.with {
    runtime_condition = create_run_condition("eslint", ".eslintrc"),
  },
  b.diagnostics.eslint_d.with {
    runtime_condition = create_run_condition("eslint", ".eslintrc"),
  },
  b.code_actions.eslint_d.with {
    runtime_condition = create_run_condition("eslint", ".eslintrc"),
  },
  --[[#########################
  --            Lua
  --#########################]]
  b.formatting.stylua,
  b.diagnostics.luacheck.with { extra_args = { "--global vim" } },
  --[[#########################
  --          Golang
  --#########################]]
  b.formatting.gofmt,
  b.formatting.goimports,
  b.diagnostics.staticcheck,
  --[[#########################
  --       Miscellaneous
  --#########################]]
  b.formatting.shfmt,
  b.diagnostics.shellcheck,
  julia,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
