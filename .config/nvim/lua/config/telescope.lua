local telescope = require('telescope')
local builtin = require('telescope.builtin')
local wk = require("which-key")

wk.register({
  f = {
    name = "+Find", -- optional group name
  },
}, { prefix = "<Space>" })

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

vim.keymap.set('n', '<Space>fb', builtin.buffers, {desc="Find buffer"})
vim.keymap.set('n', '<Space>ff', builtin.find_files, {desc="Find file"})
vim.keymap.set('n', '<Space>fg', builtin.live_grep, {desc="Live grep"})
