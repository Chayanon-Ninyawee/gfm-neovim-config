return {
    "neovim/nvim-lspconfig",
    config = function()
        local servers = {
            "lua_ls",
            "clangd",
            "rust_analyzer",
            "ruff",
            "pylsp",
            "jsonls",
            "yamlls",
        }

        vim.lsp.enable(servers)

        vim.lsp.config("pylsp", {
            settings = {
                pylsp = {
                    plugins = {
                        -- Disable default linters and formatters; use Ruff or external tools instead
                        pyflakes = { enabled = false },
                        pycodestyle = { enabled = false },
                        autopep8 = { enabled = false },
                        yapf = { enabled = false },
                        mccabe = { enabled = false },
                        pylsp_mypy = { enabled = false },
                        pylsp_black = { enabled = false },
                        pylsp_isort = { enabled = false },
                    },
                },
            }
        })

        local isPrintingHelp = false
        for _, server in ipairs(servers) do
            local cmd = vim.lsp.config[server].cmd[1]

            if vim.fn.executable(cmd) == 0 then
                isPrintingHelp = true

                vim.schedule(function()
                    vim.notify("LSP executable not found: " .. cmd, vim.log.levels.WARN)
                end)
            end
        end

        if isPrintingHelp then
            vim.schedule(function()
                vim.notify("Some LSP executables are not found! Try running :checkhealth vim.lsp", vim.log.levels.WARN)
            end)
        end
    end,
}
