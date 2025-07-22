return {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"

        vim.g.vimtex_compiler_latexmk = {
            executable = "latexmk",
            options = {
                "-xelatex", -- or -pdflatex, or -lualatex, your choice
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
                "-shell-escape",
                "-bibtex", -- This enables bibtex by default; to switch to biber, use -use-biber
            },
        }
    end,
}
