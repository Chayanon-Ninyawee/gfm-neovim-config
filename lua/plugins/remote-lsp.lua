local M = {}

function M.setup()
    local ok, remote_sshfs_module = pcall(require, "plugins.remote-sshfs")
    local remote_sshfs_root = nil
    if ok then
        remote_sshfs_root = remote_sshfs_module.opts.mounts.base_dir
    end

    vim.lsp.config("clangd", {
        root_dir = function(bufnr, on_dir)
            if
                not (
                    remote_sshfs_root
                    and vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p"):sub(1, #remote_sshfs_root)
                        == remote_sshfs_root
                )
            then
                on_dir(require("lspconfig.configs.clangd").default_config.root_dir(vim.fn.bufname(bufnr)))
            end
        end,
    })

    vim.lsp.config["remote-clangd"] = vim.fn.deepcopy(vim.lsp.config["clangd"])
    vim.lsp.config("remote-clangd", {
        root_dir = function(bufnr, on_dir)
            if
                remote_sshfs_root
                and vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p"):sub(1, #remote_sshfs_root) == remote_sshfs_root
            then
                on_dir(require("lspconfig.configs.clangd").default_config.root_dir(vim.fn.bufname(bufnr)))
            end
        end,
    })

    vim.lsp.enable("remote-clangd")
end

function M.remote_sshfs_on_connect_success(host, mount_dir)
    local lsp_proxy_path = vim.fn.stdpath("config") .. "/lsp-proxy.py"

    local sshfs_prefix = mount_dir
    local remote_prefix = host["Path"] or ("/home/" .. host["User"])

    vim.lsp.config("remote-clangd", {
        cmd = {
            "python3",
            "-u",
            lsp_proxy_path,
            host["User"] .. "@" .. (host["HostName"] or host["Name"]),
            sshfs_prefix,
            remote_prefix,
            "clangd",
        },
    })
end

return M
