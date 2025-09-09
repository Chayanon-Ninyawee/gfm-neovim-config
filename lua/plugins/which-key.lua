return {
    "folke/which-key.nvim",
    config = function()
        local wk = require("which-key")
        wk.add({
            { "<leader>S", desc = "Save Without Formatting" },
            { "<leader>s", group = "Search" },
            { "<leader>g", group = "Git Integration" },
            { "<leader>w", group = "Window Management" },
            { "<leader>f", group = "TS Incremental Selection" },

            { "<leader>x", desc = "Close Current Buffer" },
            { "<leader>X", desc = "Close Current Buffer Forcefully" },

            { "<leader>t", desc = "Toggle Stuffs" },
            { "<leader>tb", desc = "Toggle Background Transparency" },
            { "<leader>tw", desc = "Toggle Text Wrap" },
        })
    end,
}
