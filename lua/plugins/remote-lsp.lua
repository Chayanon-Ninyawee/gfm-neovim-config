local M = {}

function M.setup()
    local function setup_lsp_with_remote(lsp, root_dir)
        local remote_sshfs_root = require("remote-sshfs").config.mounts.base_dir

        vim.lsp.config(lsp, {
            root_dir = function(bufnr, on_dir)
                local fullpath = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p")
                if not (remote_sshfs_root and fullpath:sub(1, #remote_sshfs_root) == remote_sshfs_root) then
                    on_dir(root_dir(bufnr))
                end
            end,
        })

        local remote_lsp = "remote-" .. lsp
        vim.lsp.config[remote_lsp] = vim.fn.deepcopy(vim.lsp.config[lsp])
        vim.lsp.config(remote_lsp, {
            root_dir = function(bufnr, on_dir)
                local fullpath = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p")
                if remote_sshfs_root and fullpath:sub(1, #remote_sshfs_root) == remote_sshfs_root then
                    on_dir(root_dir(bufnr))
                end
            end,
        })

        vim.lsp.enable(remote_lsp)
    end

    setup_lsp_with_remote("clangd", function(bufnr)
        return require("lspconfig.configs.clangd").default_config.root_dir(vim.fn.bufname(bufnr))
    end)

    setup_lsp_with_remote("cmake", function(bufnr)
        return require("lspconfig.configs.cmake").default_config.root_dir(vim.fn.bufname(bufnr))
    end)

    require("remote-sshfs").callback.on_connect_success:add(function(host, mount_dir)
        local lsp_proxy_path = vim.fn.stdpath("config") .. "/lsp-proxy.py"

        local sshfs_prefix = mount_dir
        local remote_prefix = host["Path"] or ("/home/" .. host["User"])

        local function get_remote_cmd(cmd)
            local remote_cmd = {
                "python3",
                "-u",
                lsp_proxy_path,
                host["User"] .. "@" .. (host["HostName"] or host["Name"]),
                sshfs_prefix,
                remote_prefix,
            }

            if type(cmd) == "table" then
                for _, part in ipairs(cmd) do
                    table.insert(remote_cmd, part)
                end
            elseif type(cmd) == "string" then
                table.insert(remote_cmd, cmd)
            else
                error("Unsupported cmd type for LSP: expected table or string, got " .. type(cmd))
            end

            return remote_cmd
        end

        vim.lsp.config("remote-clangd", {
            cmd = get_remote_cmd("clangd"),
        })

        vim.lsp.config("remote-cmake", {
            cmd = get_remote_cmd("cmake-language-server"),
        })
    end)
end

return M
