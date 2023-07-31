local config = function()
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require('keymap').setup_lsp(bufnr)
    end

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    return {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end

require('lspconfig').tsserver.setup(config())
require('lspconfig').ccls.setup(config())
require('lspconfig').pyright.setup(config())
require('lspconfig').hls.setup(config())
