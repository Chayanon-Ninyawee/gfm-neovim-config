return {
    {
        "shrynx/line-numbers.nvim",
        opts = {
            mode = "both", -- "relative", "absolute", "both", "none"
            format = "abs_rel", -- or "rel_abs"
            separator = " ",
            rel_highlight = { link = "LineNr" },
            abs_highlight = { link = "LineNr" },
            current_rel_highlight = { link = "CursorLineNr" },
            current_abs_highlight = { link = "CursorLineNr" },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function(_, opts)
            local colors = require("dracula").colors()
            vim.api.nvim_set_hl(0, "IblIndent", { fg = colors.comment, nocombine = true })

            require("ibl").setup({
                indent = {
                    char = "▏",
                    highlight = "IblIndent",
                },
                scope = {
                    show_start = false,
                    show_end = false,
                    show_exact_scope = false,
                },
                exclude = {
                    filetypes = {
                        "help",
                        "startify",
                        "dashboard",
                        "packer",
                        "neogitstatus",
                        "NvimTree",
                        "Trouble",
                    },
                },
            })
        end,
    },
    {
        -- Highlight todo, notes, etc in comments
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        -- High-performance color highlighter
        "norcalli/nvim-colorizer.lua",
        config = function()
            local enabled = true

            require("colorizer").setup()

            function toggleColorizer()
                enabled = not enabled
                if enabled then
                    vim.cmd("ColorizerToggle")
                    vim.notify("Colorizer enabled", vim.log.levels.INFO)
                else
                    vim.cmd("ColorizerToggle")
                    require("colorizer").detach_from_buffer(0)
                    vim.notify("Colorizer disabled", vim.log.levels.INFO)
                end
            end

            vim.keymap.set("n", "<leader>tc", toggleColorizer, { desc = "Toggle Colorizer", noremap = true })
        end,
    },
}
