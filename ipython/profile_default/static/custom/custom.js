$.getScript("/static/components/codemirror/keymap/vim.js", function() {
    if (! IPython.Cell) return;
    IPython.Cell.options_default.cm_config.keyMap = "vim";
});

require(["nbextensions/vim"], function (vim_extension) {
    vim_extension.load_extension();
});
