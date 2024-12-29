return {
  "saghen/blink.cmp",
  version = "v0.8.2",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      ghost_text = {
        enabled = true,
      },
    },
    signature = { enabled = true, window = { border = "single" } },
    fuzzy = {
      -- Might need to download manually
      -- https://github.com/Saghen/blink.cmp/releases
      -- ~/.local/share/nvim/lazy/blink.cmp/target/release/
      prebuilt_binaries = {
        force_version = "v0.8.2",
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
