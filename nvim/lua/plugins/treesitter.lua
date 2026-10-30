-- nvim-treesitter `main` branch (the maintained one; `master` is frozen).
-- `main` has no `nvim-treesitter.configs` module and no setup() toggles:
-- it only installs parsers/queries, and highlight/indent are enabled per
-- filetype via Neovim's own APIs below.
--
-- Requires: Neovim 0.12+, a C compiler, and the tree-sitter CLI
-- (`brew install tree-sitter-cli`).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "typescript",
        "tsx",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "yaml",
      }

      -- Async; no-op for parsers that are already installed.
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "typescript",
          "typescriptreact",
          "javascript",
          "javascriptreact",
          "json",
          "lua",
          "markdown",
          "yaml",
        },
        callback = function(ev)
          -- Only start if the parser is actually available, so a buffer opened
          -- before the first `install` finishes doesn't error.
          local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
          if not pcall(vim.treesitter.language.add, lang) then
            return
          end
          vim.treesitter.start(ev.buf, lang)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
