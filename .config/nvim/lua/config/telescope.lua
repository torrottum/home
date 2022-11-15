local telescope = require('telescope')
local builtin = require('telescope.builtin')
local wk = require("which-key")

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
