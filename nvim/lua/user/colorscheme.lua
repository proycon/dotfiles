vim.g.gruvbox_baby_transparent_mode = 1
vim.g.gruvbox_baby_telescope_theme = 1
-- local colors = require("gruvbox-baby.colors").config()
-- vim.g.gruvbox_baby_highlights = {Normal = {fg = colors.orange}}

vim.cmd [[
try
  colorscheme gruvbox-baby
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]