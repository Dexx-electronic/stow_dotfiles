-- plugins/telescope
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						theme = "ivy",
					},
				},
			})
			vim.keymap.set("n", "<leader>fd", require("telescope.builtin").find_files)
			vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
			vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
			-- Telescope live_grep shortcut
			vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Telescope live grep" })
			vim.keymap.set(
				"n",
				"<leader>*",
				require("telescope.builtin").grep_string,
				{ desc = "Search word under cursor" }
			)
			vim.keymap.set("n", "<leader>en", function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end)
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
