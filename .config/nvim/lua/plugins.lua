local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()
    -- Manage packer with packager
    use 'wbthomason/packer.nvim'
    use { 'numToStr/Comment.nvim', config = [[require('Comment').setup()]] }
    use { 'neovim/nvim-lspconfig', config = [[require('config.lsp')]] }
    use {
        'L3MON4D3/LuaSnip',
        requires = {
            { 'rafamadriz/friendly-snippets', config = [[require("luasnip.loaders.from_vscode").lazy_load()]] }
        }
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'saadparwaiz1/cmp_luasnip'
        },
        config = [[require('config.cmp')]],
        after='LuaSnip'
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = [[require('lualine').setup()]]
    }
    use { 'antoinemadec/FixCursorHold.nvim', setup = [[vim.g.cursorhold_updatetime = 100]]}
    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
        config = [[require('config.telescope')]]
    }
    use {
        'folke/which-key.nvim',
        config = [[require('which-key').setup()]]
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = [[require('config.treesitter')]]
    }
    use {
        'ellisonleao/gruvbox.nvim',
        config = [[require('config.colorscheme')]]
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = [[require('config.gitsigns')]]
    }
    use {
        'TimUntersberger/neogit',
        requires = 'nvim-lua/plenary.nvim',
        config = [[require('config.neogit')]],
    }
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
        tag = 'nightly',
        config = [[require('nvim-tree').setup()]]
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
