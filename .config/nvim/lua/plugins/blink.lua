return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
      -- Override Tab to prioritize Copilot over blink.cmp completions
      -- Esc: close completion menu only (don't exit insert mode)
      ["<Esc>"] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.cancel()
            return true -- handled, don't fallback to exiting insert mode
          end
        end,
        "fallback",
      },
      ["<Tab>"] = {
        function(cmp)
          -- First: if an LSP item is explicitly selected, accept it
          if cmp.get_selected_item() then
            return cmp.accept()
          end
        end,
        -- Second: handle snippets
        "snippet_forward",
        -- Third: check for Copilot inline completion
        LazyVim.cmp.map({ "ai_accept" }),
        -- Fourth: accept first blink.cmp completion if visible (no selection)
        "select_and_accept",
        -- Finally: fall back to normal Tab
        "fallback",
      },
    },
    completion = {
      list = {
        selection = {
          -- Don't preselect first item, so Down arrow selects first item
          preselect = false,
          -- Don't auto-insert when selecting, so Esc reverts the selection
          auto_insert = false,
        },
      },
    },
    -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust" },
  },
}
