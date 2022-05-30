vim.g.gruvbox_baby_transparent_mode = 1
vim.g.gruvbox_baby_telescope_theme = 1
local colors = require("gruvbox-baby.colors").config()
vim.g.gruvbox_baby_highlights = {Search = {fg = colors.milk, bg = colors.orange}}

vim.cmd [[
if filereadable($HOME . "/.light")
    set background=light
    colorscheme zenwritten
else
    try
      colorscheme gruvbox-baby
    catch /^Vim\%((\a\+)\)\=:E185/
      colorscheme default
      set background=dark
    endtry
endif
]]
