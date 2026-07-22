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
        -- ts_ls = typescript-language-server. If you find it sluggish on the
        -- monorepo, swap this for "vtsls" (also in Mason) -- it's a drop-in
        -- alternative many people find snappier on large workspaces.
        ensure_installed = { "vtsls", "biome" },
        automatic_installation = true,
      })

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

      -- vtsls needs a classic TypeScript (tsserver.js-based) install to boot.
      -- Projects without a local node_modules/typescript (scratch files,
      -- exercise repos) fall back to the global `typescript` package -- but
      -- our global one is TypeScript 7 (the Go-native "tsgo" rewrite), which
      -- doesn't ship tsserver.js and isn't supported by any LSP client yet.
      -- We keep global `typescript` on v7 (for tsc/tsgo use) and instead pin
      -- a classic 5.x copy under nvim's data dir purely for editor tooling:
      --   npm install --prefix ~/.local/share/nvim/ts-tsdk typescript@5 --no-save
      local function global_tsdk()
        local tsdk = vim.fn.stdpath("data") .. "/ts-tsdk/node_modules/typescript/lib"
        return vim.fn.isdirectory(tsdk) == 1 and tsdk or nil
      end

      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          vtsls = {
            typescript = {
              globalTsdk = global_tsdk(),
            },
          },
        },
      })
      vim.lsp.enable("vtsls")

      -- Biome as a second LSP client running alongside ts_ls: gives you
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
