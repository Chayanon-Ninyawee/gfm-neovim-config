return { -- Highlight, edit, and navigate code
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

            local custom_parsers = {
                miniscript = {
                    repo = "https://github.com/chayanon-ninyawee/tree-sitter-miniscript.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "main",
                    filetype = "miniscript",
                    alias = "greyscript", -- optional filetype alias
                },
            }

            local function ensure_queries(parsers)
                local plugin_path = require("lazy.core.config").plugins["nvim-treesitter"].dir

                for name, info in pairs(parsers) do
                    local repo_dir = plugin_path .. "/custom_parsers/tree-sitter-" .. name
                    local source_queries = repo_dir .. "/queries/"
                    local queries_target = plugin_path .. "/queries/" .. name

                    local function link_queries()
                        if vim.fn.isdirectory(source_queries) == 1 and vim.fn.isdirectory(queries_target) == 0 then
                            vim.fn.mkdir(vim.fn.fnamemodify(queries_target, ":h"), "p")
                            vim.fn.system({ "ln", "-s", source_queries, queries_target })
                            print("Linked queries for " .. name)
                        end
                    end

                    -- clone the repo if needed
                    if vim.fn.isdirectory(repo_dir) == 0 then
                        vim.fn.jobstart({ "git", "clone", info.repo, repo_dir }, {
                            on_exit = function(_, code, _)
                                if code == 0 then
                                    print("Cloned parser repo: " .. repo_dir)
                                    link_queries()
                                else
                                    print("Failed to clone parser repo: " .. repo_dir)
                                end
                            end,
                        })
                    else
                        vim.fn.jobstart({ "git", "-C", repo_dir, "pull", "--ff-only" }, {
                            on_exit = function(_, code, _)
                                if code == 0 then
                                    link_queries()
                                else
                                    print("failed to update parser repo: " .. repo_dir)
                                end
                            end,
                        })
                    end
                end
            end

            for name, info in pairs(custom_parsers) do
                parser_config[name] = {
                    install_info = {
                        url = info.repo,
                        files = info.files,
                        branch = info.branch or "master",
                        generate_requires_npm = info.generate_requires_npm or false,
                        requires_generate_from_grammar = info.requires_generate_from_grammar or false,
                    },
                    filetype = info.filetype or name,
                }

                -- optional: filetype alias
                if info.alias then
                    vim.treesitter.language.register(name, info.alias)
                end
            end

            -- set up query links
            ensure_queries(custom_parsers)

            -- [[ configure treesitter ]] see `:help nvim-treesitter`
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
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
                    "html",
                    "css",

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

                    "miniscript",
                },

                auto_install = false,

                highlight = {
                    enable = true,
                    -- some languages depend on vim's regex highlighting system (such as ruby) for indent rules.
                    --  if you are experiencing weird indenting issues, add the language to
                    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                    additional_vim_regex_highlighting = { "ruby" },
                },
                indent = { enable = true, disable = { "ruby" } },

                refactor = {
                    highlight_definitions = {
                        enable = true,
                    },
                    highlight_current_scope = {
                        enable = false,
                    },
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<leader>fs", -- set to `false` to disable one of the mappings
                        node_incremental = "<leader>fi",
                        scope_incremental = "<leader>fc",
                        node_decremental = "<leader>fd",
                    },
                },

                textobjects = {
                    select = {
                        enable = true,

                        -- automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- you can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = { query = "@class.inner", desc = "select inner part of a class region" },
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "select language scope" },
                        },

                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            -- ["@function.outer"] = "v", -- linewise
                            ["@class.outer"] = "<c-v>", -- blockwise
                        },
                        -- if you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true or false
                        include_surrounding_whitespace = true,
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                multiwindow = false,      -- Enable multiwindow support.
                max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20,     -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            })
        end,
    },
}
