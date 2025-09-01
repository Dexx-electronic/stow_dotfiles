return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		--priority = 1000, -- ensures it loads before other UI plugins
		config = function()
			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- choose your dark theme variant
				disable_background = true,
				disable_float_background = false,
				disable_italics = false,
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
