local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = { "c","bash","lua","cpp","rust","dot","dockerfile","go","http", "json","latex","llvm","markdown_inline", "make","nu","perl","php","python","r", "rust","toml","turtle","vim","vue","yaml","zig" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "latex" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  rainbow = {
    enable= true,
    extended_mode = true,
    max_file_lines = 1000
  }
}

require('ts_context_commentstring').setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
