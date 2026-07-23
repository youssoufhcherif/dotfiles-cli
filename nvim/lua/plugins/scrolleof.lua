-- Lets scrolloff keep the cursor centered even at the end of the file, by
-- scrolling the window past EOF instead of pinning the last line to the
-- bottom. WebStorm/VSCode do this natively; vim/nvim don't without help.
return {
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {},
  },
}
