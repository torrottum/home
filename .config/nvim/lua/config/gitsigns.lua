require('gitsigns').setup{
    worktrees = {
        {
            toplevel = vim.env.HOME, gitdir = vim.env.HOME .. '/.home.git'
        }
    }
}
