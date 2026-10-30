local map = vim.keymap.set

-- Better window navigation (works alongside tmux pane nav via <leader>-prefixed or C-hjkl,
-- pick whichever doesn't collide with your tmux prefix)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Quick save / quit
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })

-- Splits, matching vim/vimrc
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>h", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on half-page jumps and search
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Telescope, LSP, and formatting keymaps live in their own plugin specs
-- (lua/plugins/telescope.lua, lua/plugins/lsp.lua, lua/plugins/formatting.lua)
-- so they're defined right next to the plugin that provides them.

-- Leave insert mode with jj (timeoutlen=400 keeps the pause short)
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Terminal: open in a split and drop straight into insert mode
map("n", "<leader>t", "<cmd>split | terminal<cr>i", { desc = "Terminal in horizontal split" })
map("n", "<leader>vt", "<cmd>vsplit | terminal<cr>i", { desc = "Terminal in vertical split" })

-- <Esc> in terminal mode goes back to normal mode (<C-\><C-n> is the built-in way).
-- Note: this means a literal Esc is no longer sent to the shell/TUI program;
-- use <C-\><C-n> if you ever need the real <C-\><C-n> behaviour from a mapping.
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation from inside a terminal split too
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
