require("gitsigns").setup({
    worktrees = {
        {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/.home.git",
        },
    },
    on_attach = function(bufnr)
        require('config.mapping').setup_lsp(bufnr)
    end
})
