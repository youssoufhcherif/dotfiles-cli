return {
  -- Installs and manages LSP servers/tools for you
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "biome" },
        automatic_installation = true,
        automatic_enable = true,
      })

      -- ts_ls/vtsls are retired in favor of tsgo/tsc below; force them off
      -- in case either is still installed via Mason from before.
      vim.lsp.enable("ts_ls", false)
      vim.lsp.enable("vtsls", false)

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gr", vim.lsp.buf.references, "Go to references")
        map("n", "K", vim.lsp.buf.hover, "Hover docs")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      end

      -- TypeScript 7 (the Go-native rewrite) speaks LSP directly via
      -- `tsc --lsp --stdio`, so no separate language-server plugin (vtsls,
      -- ts_ls) or classic tsserver.js pin is needed anymore. nvim-lspconfig
      -- ships a "tsgo" preset for this; we only override its `cmd` to run
      -- our global `tsc` (typescript@7) instead of expecting a binary
      -- literally named `tsgo`.
      vim.lsp.config("tsgo", {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = function(dispatchers, config)
          local cmd = "tsc"
          if (config or {}).root_dir then
            local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
            if vim.fn.executable(local_cmd) == 1 then
              cmd = local_cmd
            end
          end
          return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
        end,
      })
      vim.lsp.enable("tsgo")

      -- Biome as a second LSP client running alongside tsgo: gives you
      -- Biome's own diagnostics in the editor (not just at commit time via
      -- Lefthook). Formatting-on-save is handled separately by conform.nvim.
      vim.lsp.config("biome", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("biome")

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
      })
    end,
  },
}
