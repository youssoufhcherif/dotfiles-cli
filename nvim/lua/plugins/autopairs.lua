-- Auto-close brackets/quotes, and expand `{}` into a 3-line indented block
-- on <CR> between them -- WebStorm does both automatically.
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
    opts = {
      check_ts = true, -- treesitter-aware: don't pair inside strings/comments
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- Insert `(` after accepting a function/method completion.
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
