vim.keymap.set("n", "<leader>eh", function()
	require("telescope.builtin").find_files({
		cwd = vim.fn.expand("~/.config/hypr"),
		hidden = true,
	})
end)
