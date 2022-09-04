local telescope = require('telescope')
local builtin = require('telescope.builtin')
local wk = require("which-key")

wk.register({["<Leader>f"] = { name = "+find" }})

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

vim.keymap.set('n', '<Leader>fb', builtin.buffers, {desc="Find buffer"})
vim.keymap.set('n', '<Leader>ff', builtin.find_files, {desc="Find file"})
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, {desc="Live grep"})
