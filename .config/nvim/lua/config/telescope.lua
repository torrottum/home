local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup{
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key"
            }
        }
    }
}

telescope.load_extension('fzf')

vim.keymap.set('n', '<Leader>ff', builtin.find_files)
vim.keymap.set('n', '<Leader>fg', builtin.live_grep)
vim.keymap.set('n', '<Leader>fb', builtin.buffers)
vim.keymap.set('n', '<Leader>fh', builtin.help_tags)
