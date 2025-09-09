return {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
        local sig = require("lsp_signature")
        local cfg = {
            bind = true,
            handler_opts = {
                border = "none",
            },
            doc_lines = 0,

            hint_enable = true,
            hint_prefix = " Hint: ",
            hint_inline = function()
                return "eol"
            end,
        }
        sig.setup(cfg)

        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                vim.defer_fn(function()
                    sig.on_InsertLeave()
                end, 1000)
            end,
        })
    end,
}
