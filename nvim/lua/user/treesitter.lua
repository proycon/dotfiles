-- For languages not bundled, install tree-sitter-cli and run :TSInstall <lang>
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- disable legacy syntax fallback confusion (no, we still need this for some)
-- vim.cmd("syntax off")
