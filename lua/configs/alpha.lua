local M = {}

local function header_hl_today()
  local wday = os.date("*t").wday
  local colors = { "Keyword", "Constant", "Number", "Type", "String", "Special", "Function" }
  return colors[wday]
end

M.section_header = {
  type = "text",
  val = {
    [[                                                                       ]],
    [[  ██████   █████                   █████   █████  ███                  ]],
    [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
    [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
    [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
    [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
    [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
    [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
    [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
  },
  opts = {
    position = "center",
    hl = header_hl_today(),
  },
}

function M.open_project(project_path)
  local success = require("project_nvim.project").set_pwd(project_path, "alpha")
  if not success then
    return
  end
  require("telescope.builtin").find_files {
    cwd = project_path,
  }
end

function M.recent_projects(start, target_width)
  if start == nil then
    start = 1
  end
  if target_width == nil then
    target_width = 50
  end

  local has_project, project = pcall(require, "project_nvim.project")
  if not has_project then
    return require("alpha.themes.theta").mru(start, vim.fn.getcwd())
  end

  local project_history = require "project_nvim.utils.history"
  local buttons = {}
  -- Ensure current dir is added
  local root, _ = project.get_project_root()
  table.insert(project_history.session_projects, root)
  local project_paths = project_history.get_recent_projects()
  local added_projects = 0
  -- most recent project is the last
  for i = #project_paths, 1, -1 do
    if added_projects == 9 then
      break
    end
    local project_path = project_paths[i]
    local stat = vim.loop.fs_stat(project_path .. "/.git")
    if stat ~= nil and stat.type == "directory" then
      added_projects = added_projects + 1
      local shortcut = tostring(added_projects)
      local display_path = project_path:gsub(vim.env.HOME, "~")
      local path_ok, plenary_path = pcall(require, "plenary.path")
      if #display_path > target_width and path_ok then
        display_path = plenary_path.new(display_path):shorten(1, { -2, -1 })
        if #display_path > target_width then
          display_path = plenary_path.new(display_path):shorten(1, { -1 })
        end
      end
      buttons[added_projects] = {
        type = "button",
        val = " " .. display_path,
        on_press = function()
          M.open_project(project_path)
        end,
        opts = {
          position = "center",
          shortcut = shortcut,
          cursor = target_width + 3,
          width = target_width + 3,
          align_shortcut = "right",
          hl_shortcut = "Keyword",
          hl = { { "Number", 0, 3 } },
          keymap = {
            "n",
            shortcut,
            "<cmd>lua require('configs.alpha').open_project('" .. project_path .. "')<CR>",
            { noremap = true, silent = true, nowait = true },
          },
        },
      }
    end
  end
  return buttons
end

M.section_projects = {
  type = "group",
  val = {
    {
      type = "text",
      val = " Recent Projects",
      opts = {
        hl = "SpecialComment",
        shrink_margin = false,
        position = "center",
      },
    },
    { type = "group", val = M.recent_projects },
  },
}

function M.info_text()
  ---@diagnostic disable-next-line:undefined-field
  local lazy_stats = require("lazy").stats()
  local total_plugins = "󰂓 " .. lazy_stats.loaded .. "/" .. lazy_stats.count
  total_plugins = total_plugins .. " in " .. lazy_stats.startuptime .. " ms"
  local datetime = os.date " %Y-%m-%d   %A"
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return datetime .. "  " .. total_plugins .. nvim_version_info
end

M.section_info = {
  type = "text",
  val = M.info_text(),
  opts = {
    hl = "Comment",
    position = "center",
  },
}

function M.shortcuts()
  local keybind_opts = { silent = true, noremap = true }
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = { "AlphaReady" },
    callback = function(_)
      vim.api.nvim_buf_set_keymap(0, "n", "p", "<cmd>Telescope projects<CR>", keybind_opts)
      vim.api.nvim_buf_set_keymap(0, "n", "t", "<cmd>Telescope themes<CR>", keybind_opts)
      vim.api.nvim_buf_set_keymap(0, "n", "s", "<cmd>e $MYVIMRC<CR>", keybind_opts)
      vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>q<CR>", keybind_opts)
    end,
  })
  return {
    {
      type = "text",
      val = {
        " Project [p]     Themes [t]     Settings [s]     Quit [q]",
      },
      opts = {
        position = "center",
        hl = {
          { "String", 0, 18 },
          { "Keyword", 18, 36 },
          { "Function", 36, 56 },
          { "Constant", 56, 70 },
        },
      },
    },
  }
end

M.section_shortcuts = { type = "group", val = M.shortcuts }

M.config = {
  layout = {
    M.section_header,
    { type = "padding", val = 1 },
    M.section_shortcuts,
    { type = "padding", val = 1 },
    M.section_info,
    { type = "padding", val = 1 },
    M.section_projects,
  },
}

return M
