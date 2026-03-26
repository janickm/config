return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
    },
    -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust" },
  },
}
