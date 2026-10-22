return {
    {
        "Chayanon-Ninyawee/norminette42.nvim",
        opts = {
            user = "cninyawe", -- Your user.
            mail = "cninyawe@student.42bangkok.com", -- Your mail.

            norminetteArgs = "-R CheckForbiddenSourceHeader",
            -- add other options.
        },
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}

            -- Don't let Conform format C files.
            opts.formatters_by_ft.c = nil
        end,
    },
}
