-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"mason-org/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"mfussenegger/nvim-dap-python",
		"jedrzejboczar/nvim-dap-cortex-debug", -- Added for STM32 debugging
	},

	keys = {
		-- Basic debugging keymaps, feel free to change to your liking!
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
		-- Highlight errors and warnings in quickfix
		vim.api.nvim_create_augroup("ColorQuickfix", {})
		vim.api.nvim_create_autocmd("FileType", {
			group = "ColorQuickfix",
			pattern = "qf",
			callback = function()
				vim.cmd([[
        syntax match ErrorMsg /\v(error|undefined|fatal):/ containedin=ALL
        syntax match WarningMsg /\v(warning|deprecated):/ containedin=ALL
        highlight ErrorMsg ctermfg=Red guifg=Red
        highlight WarningMsg ctermfg=Yellow guifg=Yellow
      ]])
			end,
		})
		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"python",
				"bash-debug-adapter",
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
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
		vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
		vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
		local breakpoint_icons = vim.g.have_nerd_font
				and {
					Breakpoint = "",
					BreakpointCondition = "",
					BreakpointRejected = "",
					LogPoint = "",
					Stopped = "",
				}
			or {
				Breakpoint = "●",
				BreakpointCondition = "⊜",
				BreakpointRejected = "⊘",
				LogPoint = "◆",
				Stopped = "⭔",
			}
		for type, icon in pairs(breakpoint_icons) do
			local tp = "Dap" .. type
			local hl = (type == "Stopped") and "DapStop" or "DapBreak"
			vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		end

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		require("dap-python").setup()
		dap.adapters.bashdb = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
			name = "bashdb",
		}
		dap.configurations.sh = {
			{
				type = "bashdb",
				request = "launch",
				name = "Launch file",
				showDebugOutput = true,
				pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
				pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
				trace = true,
				file = "${file}",
				program = "${file}",
				cwd = "${workspaceFolder}",
				pathCat = "cat",
				pathBash = "/bin/bash",
				pathMkfifo = "mkfifo",
				pathPkill = "pkill",
				args = {},
				argsString = "",
				env = {},
				terminalKind = "integrated",
			},
		}

		--		-- Install STM32 (Cortex-M) specific config
		--		require("dap-cortex-debug").setup({
		--			extension_path = vim.fn.stdpath("data") .. "/mason/packages/cortex-debug/extension", -- Path to cortex-debug
		--		})
		--
		--		dap.configurations.c = {
		--			{
		--				name = "Debug STM32F1 (OpenOCD)",
		--				type = "cortex-debug",
		--				request = "launch",
		--				servertype = "openocd",
		--				cwd = "${workspaceFolder}",
		--				executable = "dexx-diversity.elf", -- Path to your compiled ELF file
		--				device = "STM32F103C8", -- Adjust for your specific STM32F1 chip
		--				configFiles = {
		--					"openocd.cfg", -- Path to OpenOCD config file
		--				},
		--				runToEntryPoint = "main", -- Start at main() function
		--				showDevDebugOutput = "raw", -- For verbose debug logs
		--				-- Optional: Uncomment if using STM32CubeProgrammer
		--				-- stm32CubeProgrammerPath = "/path/to/STM32CubeProgrammer/bin/STM32_Programmer_CLI",
		--			},
		-- Cortex-Debug Adapter
		require("dap-cortex-debug").setup({
			extension_path = vim.fn.stdpath("data") .. "/mason/packages/cortex-debug/extension",
		})

		-- Helper: open a Neovim terminal showing OpenOCD output
		local function open_openocd_terminal(cmd)
			vim.cmd("botright split | resize 10 | terminal " .. cmd)
			vim.cmd("file [OpenOCD]")
		end

		-- STM32F103C8 DAP Configuration
		dap.configurations.c = {
			{
				name = "STM32F103C8 (OpenOCD)",
				type = "cortex-debug",
				request = "attach",
				servertype = "openocd",
				cwd = "${workspaceFolder}",
				executable = "dexx-diversity.elf",
				device = "STM32F103C8",
				runToEntryPoint = "main",
				showDevDebugOutput = "raw",

				-- Set your OpenOCD config
				configFiles = { "openocd.cfg" },

				-- Explicit GDB path to fix missing executable error
				gdbPath = "/usr/bin/arm-none-eabi-gdb",

				--				-- Hook: before starting, open OpenOCD terminal
				--				preLaunchTask = function()
				--					-- Adjust to your OpenOCD path if needed
				--					local cmd = "openocd -f openocd.cfg"
				--					open_openocd_terminal(cmd)
				--				end,
				--
				--				postLaunchTask = function()
				--					vim.notify("OpenOCD launched in TERMINAL tab.", vim.log.levels.INFO)
				--				end,
			},
		}
	end,
}
