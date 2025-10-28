-- lua/plugins/none-ls.lua
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local mason_null = require("mason-null-ls")

		-- Ensure tools are installed globally via Mason
		mason_null.setup({
			ensure_installed = { "black", "isort", "mypy", "stylua", "ruff", "clangd", "clang-format", "cortex-debug" },
			automatic_installation = true,
		})

		-- Setup sources: all global binaries
		local sources = {
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.diagnostics.ruff,
			null_ls.builtins.diagnostics.mypy.with({}),
		}
		null_ls.setup({
			sources = sources,
		})

		-- Keymap: format file using none-ls
		vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, {
			desc = "Format file with none-ls",
		})

		-- Autoformat on save for Python and Lua
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.py", "*.lua" },
			callback = function()
				vim.lsp.buf.format({
					timeout_ms = 2000,
					filter = function(client)
						return client.name == "null-ls"
					end,
				})
			end,
		})
	end,
}
