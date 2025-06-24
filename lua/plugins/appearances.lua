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
}
