-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- Install your plugins here
local plugins = {
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
  "numToStr/Comment.nvim", -- Easily comment stuff
  "echasnovski/mini.icons",
  "kyazdani42/nvim-web-devicons",
  "kyazdani42/nvim-tree.lua",
  "akinsho/bufferline.nvim",
  "moll/vim-bbye", -- helps closing unneeded buffers
  "nvim-lualine/lualine.nvim",
  "akinsho/toggleterm.nvim",
  "ahmedkhalf/project.nvim",
  "lewis6991/impatient.nvim", -- Speed up loading Lua modules in Neovim to improve startup time.
  {
    "lukas-reineke/indent-blankline.nvim", -- add indentation guides
    main = "ibl"
  },
  { "folke/which-key.nvim", commit = "0539da0" }, -- show popup with keybindings
  { "AckslD/nvim-neoclip.lua", -- remember yanks
     dependencies = {
        -- you'll need at least one of these
        {'nvim-telescope/telescope.nvim'},
        -- {'ibhagwan/fzf-lua'},
      },
      config = function()
        require('neoclip').setup()
      end,
  },

  -- Colorschemes
  "lunarvim/colorschemes", -- A bunch of colorschemes you can try out
  "lunarvim/darkplus.nvim",
  "NLKNguyen/papercolor-theme",
  "sainnhe/everforest",
  "morhetz/gruvbox",
  "proycon/gruvbox-baby",
  {
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = { { "rktjmp/lush.nvim" } }
  },

  -- cmp plugins
  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",

  -- snippets
  "L3MON4D3/LuaSnip", --snippet engine
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig", -- enable LSP
  "tamago324/nlsp-settings.nvim", -- language server settings defined in json for
  "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters

  -- Telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-media-files.nvim",
  "benfowler/telescope-luasnip.nvim",

  -- Treesitter: provides more informed syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "JoosepAlviste/nvim-ts-context-commentstring",
  "p00f/nvim-ts-rainbow", --rainbow parantheses
  "phelipetls/jsonpath.nvim", --jq
  { -- adds a :FeMaco command to edit fenced code blocks in markdown, with proper syntax highlighting, LSP and all
      'AckslD/nvim-FeMaco.lua',
      config = 'require("femaco").setup()',
  },
  -- Git
  "lewis6991/gitsigns.nvim",

  -- Distraction free writing
  --"Pocco81/true-zen.nvim",

  "jamessan/vim-gnupg",
  "aklt/plantuml-syntax",
  --use "chrisbra/csv.vim"
  "mechatroner/rainbow_csv",
  "tpope/vim-characterize", -- unicode information on 'ga' character inspection
  "norcalli/nvim-colorizer.lua", -- show colour codes in colour
  { "ellisonleao/glow.nvim", -- markdown preview
        config = true, cmd = "Glow"
  },
  "folke/trouble.nvim", -- pretty list for showing diagnostics
  "tpope/vim-fugitive", -- git wrapper (provides :Git commands)
  {
    "simrat39/symbols-outline.nvim", --symbols (tags) tree like view (PLUGIN IS NO LONGER MAINTAINED since jan 2024!
    config = function()
            require("symbols-outline").setup()
    end
  },
  "pwntester/octo.nvim", -- github CLI integration
{
      "ray-x/lsp_signature.nvim", -- Show function signature as you type
      event = "VeryLazy",
},
  "goerz/jupytext.vim", -- edit ipynb as markdown via jupytext
  "fatih/vim-go", -- Go
  "simrat39/inlay-hints.nvim", -- Inlay hints (e.g for Rust)
  -- use "simrat39/rust-tools.nvim" -- Rust, used for inlay hints and more
  -- use 'mfussenegger/nvim-dap' -- Debugger
  "https://git.sr.ht/~sotirisp/vim-tsv",
  "proycon/todo.txt-vim", -- my own extended todo.txt syntax highlighting
  "dylon/vim-antlr",
  { "glacambre/firenvim",
     build = ":call firenvim#install(0)"
  },
  'sQVe/sort.nvim'
}

local function getLinuxDistroFromReleaseFile()
    local f = io.open("/etc/os-release", "r")
    if not f then return nil end

    for line in f:lines() do
        if line:match("^ID=") then
            local distroName = line:gsub("ID=",""):gsub("\"","")
            return distroName
        end
    end
    f:close()
    return nil
end
local distro = getLinuxDistroFromReleaseFile()
if distro ~= "postmarketos" and distro ~= "alpine" then
   table.insert(plugins,
      {
        -- for this we need to install: luarocks --local --lua-version=5.1 install nvim-nio
        "rest-nvim/rest.nvim",
        dependencies = {
          "j-hui/fidget.nvim",
          "nvim-treesitter/nvim-treesitter",
          opts = function (_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "http")
          end,
        }
      })
end

local opts = {}

require("lazy").setup(plugins, opts)
