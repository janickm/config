-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Prevent Copilot LSP from running on files in the encrypted data folder
local blocked_dir = vim.fn.expand("$HOME") .. "/Private/"

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("block_copilot_sensitive_dirs", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "copilot" then
      return
    end
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path:sub(1, #blocked_dir) == blocked_dir then
      vim.schedule(function()
        vim.lsp.buf_detach_client(args.buf, client.id)
      end)
    end
  end,
})
