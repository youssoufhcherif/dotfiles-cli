return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "biome" },
          typescript = { "biome" },
          typescriptreact = { "biome" },
          javascriptreact = { "biome" },
          json = { "biome" },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      })

      vim.keymap.set("n", "<leader>mp", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer with Biome" })
    end,
  },
}
