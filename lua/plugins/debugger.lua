return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",
        -- Required dependency for nvim-dap-ui
        "nvim-neotest/nvim-nio",

        {
            "stevearc/overseer.nvim",
            config = function()
                require("overseer").setup()

                vim.keymap.set("n", "<leader>to", "<cmd>OverseerToggle<CR>", { desc = "Toggle Overseer UI" })
            end,
        },

        -- Add your own debuggers here
        "mfussenegger/nvim-dap-python",
    },
    keys = {
        {
            "<F5>",
            function()
                require("dap").continue()
            end,
            desc = "Debug: Start/Continue",
        },
        {
            "<F1>",
            function()
                require("dap").step_into()
            end,
            desc = "Debug: Step Into",
        },
        {
            "<F2>",
            function()
                require("dap").step_over()
            end,
            desc = "Debug: Step Over",
        },
        {
            "<F3>",
            function()
                require("dap").step_out()
            end,
            desc = "Debug: Step Out",
        },
        {
            "<leader>b",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Debug: Toggle Breakpoint",
        },
        {
            "<leader>B",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Debug: Set Breakpoint",
        },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        {
            "<F7>",
            function()
                require("dapui").toggle()
            end,
            desc = "Debug: See last session result.",
        },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        -- Change breakpoint icons
        -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
        -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
        -- local breakpoint_icons = vim.g.have_nerd_font
        --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
        -- for type, icon in pairs(breakpoint_icons) do
        --   local tp = 'Dap' .. type
        --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        -- end

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        -- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        -- dap.listeners.before.event_exited["dapui_config"] = dapui.close

        require("dap.ext.vscode").load_launchjs(nil, {
            codelldb = { "c", "cpp" },
            cppdbg = { "c", "cpp" },
        })

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/codelldb/adapter/codelldb",
                args = { "--port", "${port}" },
            },
        }

        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp

        require("dap-python").setup("~/.local/share/pipx/venvs/debugpy/bin/python3")
    end,
}
