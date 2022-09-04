local config = function()
    -- TODO: move to utility file?
    local map = function(mode, lhs, rhs, buffer, desc)
        local bufopts = { noremap=true, silent=true, buffer=buffer, desc=desc }
        vim.keymap.set(mode, lhs, rhs, bufopts)
    end

    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        map('n', 'gD', vim.lsp.buf.declaration, bufnr, 'Jump to declaration')
        map('n', 'gd', vim.lsp.buf.definition, bufnr, 'Jump to definition')

        map('n', 'K', vim.lsp.buf.hover, bufnr, 'LSP Hover')
        map('n', 'gi', vim.lsp.buf.implementation, bufnr, 'Jump to implementation')
        map('n', '<C-k>', vim.lsp.buf.signature_help, bufnr, 'View signature help')
        map('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufnr, 'Add workspace folder')
        map('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufnr, 'Remove workspace folder')
        map('n', '<Leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufnr, 'List workspace folders')
        map('n', '<Leader>D', vim.lsp.buf.type_definition, bufnr, 'Jump to type definition')
        map('n', '<Leader>rn', vim.lsp.buf.rename, bufnr, 'LSP Rename')
        map('n', '<Leader>ca', vim.lsp.buf.code_action, bufnr, 'LSP Code action')
        map('n', 'gr', vim.lsp.buf.references, bufnr, 'View references')
        map('n', '<Leader>F', vim.lsp.buf.formatting, bufnr, 'Format code')
    end

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    return {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end


require('lspconfig').tsserver.setup(config())
require('lspconfig').terraformls.setup(config())
require('lspconfig').ccls.setup(config())
require('lspconfig').pyright.setup(config())

-- TODO: move this somewhere else
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function() vim.lsp.buf.format() end
})
