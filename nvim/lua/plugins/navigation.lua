-- Seamless navigation between nvim splits and tmux panes with <C-h/j/k/l>.
-- The tmux side (christoomey/vim-tmux-navigator plugin in ~/.tmux.conf) forwards
-- <C-h/j/k/l> into nvim when nvim is the active pane; this plugin catches them
-- and moves across the vim<->tmux boundary in one keystroke, no prefix needed.
return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left (split/pane)" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down (split/pane)" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up (split/pane)" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (split/pane)" },
    },
  },
}
