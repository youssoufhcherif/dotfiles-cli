return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          -- Respects your workspace's .gitignore, skips node_modules etc.
          file_ignore_patterns = { "node_modules", "dist", "%.git/" },
        },
      })

      local map = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Grep across project (search everywhere)" })
      map("n", "<leader>b", builtin.buffers, { desc = "List open buffers" })
      map("n", "<leader>fr", builtin.oldfiles, { desc = "Recently opened files" })
      map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics list" })
    end,
  },
}
