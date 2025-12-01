-- load default LSP settings from nvchad
-- This call sets up the default capabilities, keybindings, and on_attach logic
require("nvchad.configs.lspconfig").defaults()

-- You no longer need to 'require "lspconfig"' explicitly for setup

-- add your LSPs here
local servers = {
  "html",
  "cssls",
  "basedpyright",
  "rust_analyzer",
  "ts_ls",
}

-- Custom configuration for specific servers uses vim.lsp.config()

-- Configure 'basedpyright' (The custom setup you had)
-- The 'on_attach', 'on_init', and 'capabilities' are already handled
-- by the 'nvchad.configs.lspconfig'.defaults() call above, so we only
-- need to pass the unique settings here.
vim.lsp.config("basedpyright", {
  filetypes = { "python" },
  settings = {
    basedpyright = {
      typeCheckingMode = "off",
      -- reportUnusedVariable = "none",
    },
  },
})

-- For all other servers (html, cssls, rust_analyzer, ts_ls), the defaults
-- set by NvChad are automatically used by the 'vim.lsp.enable' call below.

-- Enable all servers on the list
-- This is the modern way to activate LSPs once they are configured (either
-- via their default configuration or a custom vim.lsp.config() call).
vim.lsp.enable(servers)

-- Note: The loop you had is no longer needed because
-- 1. Default settings are handled by `nvchad.configs.lspconfig`.defaults().
-- 2. Custom settings are handled by `vim.lsp.config()` (like for basedpyright).
-- 3. Activation is handled once by `vim.lsp.enable(servers)`.
