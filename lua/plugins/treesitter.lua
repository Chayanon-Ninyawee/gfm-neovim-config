return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            -- Add filetype for miniscript
            vim.filetype.add({
                extension = {
                    ms = "miniscript",
                    src = "miniscript",
                },
            })
            -- Add treesitter for miniscript
            vim.api.nvim_create_autocmd("User", {
                pattern = "TSUpdate",
                callback = function()
                    require("nvim-treesitter.parsers").miniscript = {
                        install_info = {
                            url = "https://github.com/Chayanon-Ninyawee/tree-sitter-miniscript.git",
                            revision = "ca8d69fa4361d07e74c0f0c94853dc1e0a7d7f10",
                            queries = "queries",
                        },
                    }
                end,
            })
            vim.treesitter.language.register("miniscript", { "miniscript" })

            require("nvim-treesitter").install({
                -- core languages you use
                "lua",
                "c",
                "cpp",
                "python",
                "bash",
                "cmake",
                "make",

                -- web-related
                "javascript",
                "typescript",
                "html",
                "css",
                "svelte",

                -- config and data formats
                "json",
                "yaml",
                "toml",
                "ini",

                -- git & docs
                "markdown",
                "gitcommit",
                "git_rebase",
                "vimdoc",

                -- jvm languages
                "java",
                "kotlin",
                "groovy",

                "scheme",

                -- custom parser
                "miniscript",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },

        init = function()
            vim.g.no_plugin_maps = true
        end,

        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,

                    selection_modes = {
                        ["@parameter.outer"] = "v",
                        ["@function.outer"] = "v",
                        ["@class.outer"] = "v",
                    },

                    include_surrounding_whitespace = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")

            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@function.outer", "textobjects", vim.fn.mode())
            end)

            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@function.inner", "textobjects", vim.fn.mode())
            end)

            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@class.outer", "textobjects", vim.fn.mode())
            end)

            vim.keymap.set({ "x", "o" }, "ic", function()
                select.select_textobject("@class.inner", "textobjects", vim.fn.mode())
            end)

            vim.keymap.set({ "x", "o" }, "as", function()
                select.select_textobject("@local.scope", "locals", vim.fn.mode())
            end)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = false,
                max_lines = 0,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = "outer",
                mode = "cursor",
                separator = nil,
                zindex = 20,
                on_attach = nil,
            })
        end,
    },
}
