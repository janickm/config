-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.lsp.config("ty", {
  settings = {
    ty = {
      -- inlayHints = {
      --   variableTypes = false,
      --   callArgumentNames = false,
      -- },
      diagnosticMode = "workspace",
    },
  },
})

-- vim.g.lazyvim_cmp = "blink.cmp"

-- set to `true` to follow the main branch
-- you need to have a working rust toolchain to build the plugin
-- in this case.
-- vim.g.lazyvim_blink_main = true

-- vim.o.winborder = "double"

if vim.g.neovide or vim.env.SSH_CONNECTION or vim.env.SSH_TTY then
  -- vim.o.guifont = "DejaVuSansM Nerd Font Mono,DejaVuSansMono Nerd Font Mono:h11"
  vim.o.guifont = "DejaVuSansM Nerd Font,DejaVuSansMono Nerd Font:h11"
end
