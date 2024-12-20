local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  --use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use "echasnovski/mini.icons"
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye" -- helps closing unneeded buffers
  use "nvim-lualine/lualine.nvim"
  use "akinsho/toggleterm.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim" -- Speed up loading Lua modules in Neovim to improve startup time.
  use {
    "lukas-reineke/indent-blankline.nvim", -- add indentation guides
    main = "ibl"
  }
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use { "folke/which-key.nvim", commit = "0539da0" } -- show popup with keybindings
  use { "AckslD/nvim-neoclip.lua", -- remember yanks
     requires = {
        -- you'll need at least one of these
        {'nvim-telescope/telescope.nvim'},
        -- {'ibhagwan/fzf-lua'},
      },
      config = function()
        require('neoclip').setup()
      end,
  }

  -- Colorschemes
  use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"
  use "NLKNguyen/papercolor-theme"
  use "sainnhe/everforest"
  use "morhetz/gruvbox"
  use "proycon/gruvbox-baby"
  --use "luisiacc/gruvbox-baby"
  use {
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    requires = "rktjmp/lush.nvim"
  }

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use { "williamboman/mason.nvim",
    config = function()
            require("mason").setup()
    end
}
  use "williamboman/mason-lspconfig.nvim"
  use {
        "neovim/nvim-lspconfig", -- enable LSP
  }
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"
  use "benfowler/telescope-luasnip.nvim"

  -- Treesitter: provides more informed syntax highlighting
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "p00f/nvim-ts-rainbow" --rainbow parantheses
  use "phelipetls/jsonpath.nvim" --jq
  use { -- adds a :FeMaco command to edit fenced code blocks in markdown, with proper syntax highlighting, LSP and all
      'AckslD/nvim-FeMaco.lua',
      config = 'require("femaco").setup()',
  }

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Distraction free writing
  use "Pocco81/true-zen.nvim"

  use "jamessan/vim-gnupg"
  use "aklt/plantuml-syntax"
  --use "chrisbra/csv.vim"
  use "mechatroner/rainbow_csv"
  use "tpope/vim-characterize" -- unicode information on 'ga' character inspection
  use "norcalli/nvim-colorizer.lua" -- show colour codes in colour
  use { "ellisonleao/glow.nvim", -- markdown preview
        config = function() require("glow").setup() end 
  }
  use "folke/trouble.nvim" -- pretty list for showing diagnostics
  use "tpope/vim-fugitive" -- git wrapper (provides :Git commands)
  use {
    "simrat39/symbols-outline.nvim", --symbols (tags) tree like view
    config = function() 
            require("symbols-outline").setup()
    end
  }
  use "pwntester/octo.nvim" -- github CLI integration
  use { 
        "ray-x/lsp_signature.nvim", -- Show function signature as you type
        config = function()
            require('lsp_signature').setup({
                floating_window_off_y = -1
            })
        end
  }
  use "goerz/jupytext.vim" -- edit ipynb as markdown via jupytext
  use "fatih/vim-go" -- Go
  use "simrat39/inlay-hints.nvim" -- Inlay hints (e.g for Rust)
  -- use "simrat39/rust-tools.nvim" -- Rust, used for inlay hints and more
  -- use 'mfussenegger/nvim-dap' -- Debugger
  use "https://git.sr.ht/~sotirisp/vim-tsv"
  use "proycon/todo.txt-vim" -- my own extended todo.txt syntax highlighting
  use { "glacambre/firenvim",
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    run = function() vim.fn['firenvim#install'](0) end 
    --cond = not not vim.g.started_by_firenvim,
    --build = function()
    --    require("lazy").load({ plugins = "firenvim", wait = true })
    --    vim.fn["firenvim#install"](0)
    --end
  }
  use({
    'sQVe/sort.nvim',

  -- Optional setup for overriding defaults.
    config = function()
     require("sort").setup({
      -- Input configuration here.
      -- Refer to the configuration section below for options.
     })
     end
  })
  use {
      'yetone/avante.nvim',
      build = ":AvanteBuild",
      lazy = false,
      version = false,
      BUILD_FROM_SOURCE = true,
      config = function()
          require('avante_lib').load()
          require('avante').setup()
      end,
      requires = {
          'nvim-tree/nvim-web-devicons',
          'stevearc/dressing.nvim',
          'nvim-lua/plenary.nvim',
          'MunifTanjim/nui.nvim',
          {
              'MeanderingProgrammer/render-markdown.nvim',
              config = function()
                  require('render-markdown').setup({
                      file_types = { "markdown", "Avante" },
                  })
              end,
          },
      },
      run = 'make', -- Optional, only if you want to use tiktoken_core to calculate tokens count
  }


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
