require "options"
require "mappings"
require "commands"
local github = require "github"

-- bootstrap plugins & lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim" -- path where its going to be installed

if not vim.loop.fs_stat(lazypath) then
  vim.api.nvim_echo({ { "Cloning lazy.nvim", "Bold" } }, true, {})
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    github .. "folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { colorscheme = { "onenord" } },
  git = { url_format = github .. "%s.git" },
  concurrency = 8,
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})

if vim.g.neovide then
  vim.o.guifont = "ComicShannsMono Nerd Font,Source Code Pro,Noto Sans CJK SC:h15"
  vim.g.neovide_transparency = 0.95
end

