return {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local dracula = require("dracula")
        dracula.setup({
            transparent_bg = true,
        })

        vim.cmd([[colorscheme dracula]])

        -- Toggle background transparency
        local bg_transparent = true

        local toggle_transparency = function()
            bg_transparent = not bg_transparent
            dracula.setup({
                transparent_bg = bg_transparent,
            })
            vim.cmd([[colorscheme dracula]])
        end

        vim.keymap.set("n", "<leader>tb", toggle_transparency, { noremap = true, silent = true })
    end,
}
