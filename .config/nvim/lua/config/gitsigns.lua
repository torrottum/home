require('gitsigns').setup{
    debug_mode = true,
    worktrees = {
        {
            toplevel = vim.env.HOME, gitdir = vim.env.HOME .. '/.homerepo'
        }
    }
}
