require("gitsigns").setup({
    worktrees = {
        {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/.home.git",
        },
    },
    on_attach = function(bufnr)
        require('keymap').setup_gitsigns(bufnr)
    end
})
