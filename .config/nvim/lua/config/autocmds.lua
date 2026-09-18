-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Follow the file given on the command line: `nvim ~/.claude/settings.json` puts cwd
-- at ~/.claude rather than wherever the shell was. Nearest .git/.jj wins, so inside a
-- repo the cwd becomes the repo root and pickers/grep stay project-wide.
-- Set `vim.g.startup_chdir = false` to disable; `:CdRoot` does the same on demand.
local function root_of(path)
  local dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
  if vim.fn.isdirectory(dir) == 0 then
    return nil
  end
  local marker = vim.fs.find({ ".git", ".jj" }, { path = dir, upward = true })[1]
  return marker and vim.fs.dirname(marker) or dir
end

local function chdir(path)
  if path == "" then
    return
  end
  local root = root_of(vim.fn.fnamemodify(path, ":p"))
  if root and root ~= vim.uv.cwd() then
    vim.cmd.cd(vim.fn.fnameescape(root))
  end
end

vim.api.nvim_create_user_command("CdRoot", function()
  chdir(vim.api.nvim_buf_get_name(0))
end, { desc = "cd to the current file's repo root, or its own directory" })

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("startup_chdir", { clear = true }),
  once = true,
  callback = function()
    if vim.g.startup_chdir ~= false and vim.fn.argc(-1) > 0 then
      chdir(vim.fn.argv(0))
    end
  end,
})

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
