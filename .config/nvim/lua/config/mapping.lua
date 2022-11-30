local wk = require("which-key")

local M = {}
local function add_desc(opts, desc)
    opts = opts or {}
    opts.desc = desc
    return opts
end

M.setup = function()
    wk.register({
        ["<leader>f"] = { name = "+Find" },
        ["<leader>t"] = { name = "+Toggle" },
        ["<leader>g"] = { name = "+Git" },
        ["<leader>h"] = { name = "+Git" },
    })
    local neogit = require("neogit")

    local opts = { noremap = true }
    vim.keymap.set("n", "<leader>j", ":bprev <CR>", add_desc(opts, "Previous buffer"))
    vim.keymap.set("n", "<leader>k", ":bnext <CR>", add_desc(opts, "Next buffer"))
    vim.keymap.set("n", "<leader>d", ":bd <CR>", add_desc(opts, "Delete buffer"))
    vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", add_desc(opts, "Find buffer"))
    vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", add_desc(opts, "Find file"))
    vim.keymap.set("n", "<leader>fg", ":Telescope git_files<CR>", add_desc(opts, "Find git file"))
    vim.keymap.set("n", "<leader>fl", ":Telescope live_grep<CR>", add_desc(opts, "Live grep"))

    vim.keymap.set("n", "<leader>gg", ":Neogit kind=split<CR>", add_desc(opts, "Neogit"))
    vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", add_desc(opts, "Git status"))
    vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", add_desc(opts, "Git commit"))
    vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", add_desc(opts, "Git branches"))
    vim.keymap.set("n", "<leader>gl", ":Telescope git_commits<CR>", add_desc(opts, "Git commits"))
    vim.keymap.set("n", "<leader>gL", ":Telescope git_bcommits<CR>", add_desc(opts, "Git branch commits"))

    vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>", add_desc(opts, "Toggle NvimTree"))

    vim.keymap.set("n", "<leader>F", ":Neoformat<CR>", add_desc(opts, "Run neoformat on buffer"))
end

M.setup_lsp = function(bufnr)
    local bufopts = { noremap = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, add_desc(bufopts, "Jump to declaration"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, add_desc(bufopts, "Jump to definition"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, add_desc(bufopts, "LSP Hover"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, add_desc(bufopts, "Jump to implementation"))
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, add_desc(bufopts, "Signature help"))
    wk.register({ ["<leader>w"] = { name = "+Workspace" } })
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, add_desc(bufopts, "Add workspace folder"))
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, add_desc(bufopts, "Remove workspace folder"))
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, add_desc(bufopts, "List workspace folders"))
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, add_desc(bufopts, "Type defintion"))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, add_desc(bufopts, "Rename"))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, add_desc(bufopts, "Code action"))
    vim.keymap.set("n", "gr", ":Telescope lsp_references<cr>", add_desc(bufopts, "View references"))
end

M.setup_gitsigns = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Navigation
    vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
            return "]c"
        end
        vim.schedule(function()
            gs.next_hunk()
        end)
        return "<Ignore>"
    end, { expr = true })

    vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
            return "[c"
        end
        vim.schedule(function()
            gs.prev_hunk()
        end)
        return "<Ignore>"
    end, { expr = true })

    local bufopts = { noremap = true, buffer = bufnr }
    -- Actions
    vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", add_desc(bufopts, "stage hunk"))
    vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", add_desc(bufopts, "Reset hunk"))
    vim.keymap.set("n", "<leader>hS", gs.stage_buffer, add_desc(bufopts, "Stage buffer"))
    vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, add_desc(bufopts, "Undo stage hunk"))
    vim.keymap.set("n", "<leader>hR", gs.reset_buffer, add_desc(bufopts, "Reset buffer"))
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, add_desc(bufopts, "Preview hunk"))
    vim.keymap.set("n", "<leader>gb", function()
        gs.blame_line({ full = true })
    end, add_desc(bufopts, "blame line"))
    vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, add_desc(bufopts, "Gitsigns toggle blame"))
    vim.keymap.set("n", "<leader>gd", gs.diffthis, add_desc(bufopts, "Diff this"))
    vim.keymap.set("n", "<leader>gD", function()
        gs.diffthis("~")
    end, add_desc(bufopts, "Diff this ~"))
    vim.keymap.set("n", "<leader>td", gs.toggle_deleted, add_desc(bufopts, "Gitsigns toggle deleted"))

    -- Text object
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

return M
