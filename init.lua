require("core.options")

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader key will be used)
require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "rcarriga/nvim-notify",
            lazy = false,
            config = function()
                local colors = require("dracula").colors()
                require("notify").setup({
                    background_colour = colors.bg,
                })

                vim.notify = require("notify")
            end,
        },
        require("plugins.colorscheme"),
        require("plugins.appearances-misc"),
        require("plugins.lualine"),
        require("plugins.bufferline"),
        require("plugins.alpha"),
        require("plugins.neotree"),
        require("plugins.image"),
        require("plugins.telescope"),
        require("plugins.editor-misc"),
        require("plugins.gitsigns"),
    },
    checker = { enabled = true },
})
