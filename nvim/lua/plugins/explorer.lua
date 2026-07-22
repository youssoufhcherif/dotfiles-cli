return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        filters = { dotfiles = false },
        git = { enable = true },
      })
      local api = require("nvim-tree.api")
      vim.keymap.set("n", "<leader>1", api.tree.toggle, { desc = "Toggle file tree" })
      vim.keymap.set("n", "<leader>2", function()
        api.tree.find_file({ open = true, focus = true })
      end, { desc = "Reveal current file in tree" })
    end,
  },

  -- Inline git blame / hunk navigation, similar to WebStorm's gutter git markers
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
}
