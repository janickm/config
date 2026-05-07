-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Workaround for https://github.com/neovim/neovim/issues/38651
-- VSCode's terminal does not send the correct key codes for
-- shifted digits, so we remap them to their expected values.
if vim.env.TERM_PROGRAM == "vscode" then
  -- Adjust to match your keyboard layout if necessary
  local shifted_digits = {
    ["<S-1>"] = "!",
    ["<S-2>"] = "@",
    ["<S-3>"] = "#",
    ["<S-4>"] = "$",
    ["<S-5>"] = "%",
    ["<S-6>"] = "&",
    ["<S-7>"] = "^",
    ["<S-8>"] = "*",
    ["<S-9>"] = "(",
    ["<S-0>"] = ")",
  }

  for lhs, rhs in pairs(shifted_digits) do
    vim.keymap.set({ "n", "x", "i" }, lhs, rhs, {
      noremap = true,
      silent = true,
    })

    vim.keymap.set("c", lhs, function()
      return rhs
    end, {
      expr = true,
      noremap = true,
    })
  end
end
