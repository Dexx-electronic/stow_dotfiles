return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup({
				mappings = {
					-- Toggle comment on current line (like `gcc`)
					comment_line = "gcc",

					-- Toggle comment on visual selection (like `gc`)
					comment_visual = "gc",

					-- Toggle comment on motion (like `gc{motion}`)
					comment = "gc",
				},
			})

			-- require("mini.statusline").setup()
			-- Add more modules as needed
		end,
	},
}
