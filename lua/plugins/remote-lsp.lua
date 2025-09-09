return {
    "Chayanon-Ninyawee/remote-lsp.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "Chayanon-Ninyawee/remote-sshfs.nvim",
    },
    opts = {
        servers = {
            clangd = { cmd = "clangd --background-index" },
            cmake = { cmd = "cmake-language-server" },
            bashls = { cmd = { "bash-language-server", "start" } },
        },
    },
}
