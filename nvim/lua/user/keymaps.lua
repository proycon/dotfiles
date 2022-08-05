local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Custom --
keymap("n", "<C-b>", ":Gitsigns blame_line<CR>", opts)
keymap("n", "<leader>L", ":TroubleToggle<CR>", opts)
keymap("n", "<leader>T", ":SymbolsOutline<CR>", opts)
keymap("n", "<leader>o", ":Telescope git_files<CR>", opts)

-- custom copy'n'paste
-- copy the current visual selection to ~/.vbuf
keymap("v", "<leader>y", ":w! ~/.vbuf<CR>:!~/dotfiles/updatevbuf.sh<CR>", opts)
-- copy the current line to the buffer file if no visual selection
keymap("n", "<leader>y", ":.w! ~/.vbuf<CR>:!~/dotfiles/updatevbuf.sh<CR>", opts)
keymap("n", ",y", ":w! ~/.vbuf<CR>:!xsel -i -b < ~/.vbuf<CR>", opts)
keymap("n", ",p", ":r ~/.vbuf<CR>", opts)
keymap("n", ",P", ":-1r ~/.vbuf<CR>", opts)

keymap("n", "<F9>", ":Git commit -a<CR>", opts)
keymap("n", "<F10>", ":Git push<CR>", opts)
keymap("n", "<F12>", ":Octo issue list<CR>", opts)

-- Cyrillic in normal mode, map some minimal cyrillic so I don't have to switch
keymap("n", "и", "i", opts)
keymap("n", "ы", "y", opts)
keymap("n", "ч", "c", opts)
keymap("n", "п", "p", opts)
keymap("n", "о", "o", opts)
keymap("n", "х", "h", opts)
keymap("n", "й", "j", opts)
keymap("n", "к", "k", opts)
keymap("n", "л", "l", opts)
keymap("n", "ж", ":", opts)
keymap("n", "а", "a", opts)
keymap("n", "д", "d", opts)
keymap("n", "в", "v", opts)
keymap("n", "б", "b", opts)
keymap("n", "н", "n", opts)
keymap("n", "м", "m", opts)
