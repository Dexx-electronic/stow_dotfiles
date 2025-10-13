-- lua/plugins/lsp.lua
return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "bashls", "pyright", "clangd" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Buffer-local keymaps for LSP
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			end

			-- Diagnostics configuration
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- Lua LSP
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			-- Bash LSP
			lspconfig.bashls.setup({ on_attach = on_attach, capabilities = capabilities })
			-- Clangd
			lspconfig.clangd.setup({
				cmd = { "clangd" },
				filetypes = { "c", "cpp" },
				root_dir = require("lspconfig.util").root_pattern("Makefile", ".git"),
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Python LSP with project .venv detection
			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				before_init = function(_, config)
					local venv = vim.fn.getcwd() .. "/.venv"
					if vim.fn.isdirectory(venv) == 1 then
						config.settings.python.pythonPath = venv .. "/bin/python"
					end
				end,
			})
		end,
	},
}
