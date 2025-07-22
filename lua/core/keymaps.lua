-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Find and center
vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

-- Escape insert mode using Ctrl+C
vim.keymap.set("i", "<C-c>", "<Esc>", {
    desc = "Exit insert mode",
    noremap = true,
    silent = true,
})

-- Save file with Ctrl+S
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", {
    desc = "Save file",
    noremap = true,
    silent = true,
})

-- Save file without triggering auto-format
vim.keymap.set("n", "<leader>S", "<cmd>noautocmd w <CR>", {
    desc = "Save without formatting",
    noremap = true,
    silent = true,
})

-- Quit file with Ctrl+Q
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", {
    desc = "Quit file",
    noremap = true,
    silent = true,
})

-- Force quit
vim.keymap.set("n", "<leader>Q", "<cmd> q! <CR>", {
    desc = "Force quit file",
    noremap = true,
    silent = true,
})

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", {
    desc = "Resize splits up",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<Down>", ":resize +2<CR>", {
    desc = "Resize splits down",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", {
    desc = "Resize splits left",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", {
    desc = "Resize splits right",
    noremap = true,
    silent = true,
})

-- Buffers
local function close_buffer(isForce)
    -- Check if the :Neotree command exists (i.e., Neo-tree is installed)
    local has_neotree = vim.fn.exists(":Neotree") == 2
    local was_open = false

    if has_neotree then
        -- Loop through all open windows to check if any is a Neo-tree window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
            if bufname:match("neo%-tree") then
                was_open = true
                -- Close Neo-tree temporarily
                vim.cmd("Neotree close")
                break
            end
        end
    end

    -- Close the current buffer
    vim.cmd(isForce and "bdelete!" or "bdelete")

    -- Reopen Neo-tree if it was previously open and is available
    if was_open and has_neotree then
        vim.cmd("Neotree show")
    end
end
vim.keymap.set("n", "<Tab>", ":bnext<CR>", {
    desc = "Next buffer",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", {
    desc = "Previous buffer",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<leader>x", function()
    close_buffer(false)
end, {
    desc = "Close buffer",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<leader>X", function()
    close_buffer(true)
end, {
    desc = "Force close buffer",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<leader>nb", "<cmd> enew <CR>", {
    desc = "New buffer",
    noremap = true,
    silent = true,
})
-- Window management
vim.keymap.set("n", "<leader>wv", "<C-w>v", {
    desc = "Split window vertically",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<leader>wh", "<C-w>s", {
    desc = "Split window horizontally",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<leader>we", "<C-w>=", {
    desc = "Equalize split sizes",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<leader>wx", ":close<CR>", {
    desc = "Close current split",
    noremap = true,
    silent = true,
})

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", {
    desc = "Move to upper split",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", {
    desc = "Move to lower split",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", {
    desc = "Move to left split",
    noremap = true,
    silent = true,
})
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", {
    desc = "Move to right split",
    noremap = true,
    silent = true,
})

-- Toggle line wrapping
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", {
    desc = "Toggle line wrap",
    noremap = true,
    silent = true,
})

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", {
    desc = "Indent left and reselect",
    noremap = true,
    silent = true,
})
vim.keymap.set("v", ">", ">gv", {
    desc = "Indent right and reselect",
    noremap = true,
    silent = true,
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
    desc = "Go to previous diagnostic message",
})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
    desc = "Go to next diagnostic message",
})
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
    desc = "Open floating diagnostic message",
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
    desc = "Open diagnostics list",
})
