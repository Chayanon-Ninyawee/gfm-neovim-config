return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({

            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettier" },
                yaml = { "prettier" }
            },
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        })

        local isPrintingHelp = false
        for ft, formatters in pairs(require("conform").formatters_by_ft) do
            for _, formatter in ipairs(formatters) do
                if type(formatter) == "string" then -- Only check if it's a string (command)
                    if vim.fn.executable(formatter) == 0 then
                        isPrintingHelp = true

                        vim.schedule(function()
                            vim.notify("Formatter executable not found: " .. formatter, vim.log.levels.WARN)
                        end)
                    end
                end
            end
        end

        if isPrintingHelp then
            vim.schedule(function()
                vim.notify("Some Formatter executables are not found! Try running :checkhealth conform",
                    vim.log.levels.WARN)
            end)
        end
    end
}
