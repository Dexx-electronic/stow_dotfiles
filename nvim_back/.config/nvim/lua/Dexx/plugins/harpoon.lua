return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2", -- use harpoon2 for latest version
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
			})

			-- Keybindings
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }

			-- Add current file to Harpoon
			map("n", "<leader>a", function()
				harpoon:list():add()
			end, opts)

			-- Toggle Harpoon UI
			map("n", "<leader>hh", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, opts)

			-- Navigate to files
			map("n", "<leader>h1", function()
				harpoon:list():select(1)
			end, opts)
			map("n", "<leader>h2", function()
				harpoon:list():select(2)
			end, opts)
			map("n", "<leader>h3", function()
				harpoon:list():select(3)
			end, opts)
			map("n", "<leader>h4", function()
				harpoon:list():select(4)
			end, opts)
			map("n", "<leader>h5", function()
				harpoon:list():select(5)
			end, opts)
			map("n", "<leader>h6", function()
				harpoon:list():select(6)
			end, opts)
			map("n", "<leader>h7", function()
				harpoon:list():select(7)
			end, opts)
		end,
	},
}
