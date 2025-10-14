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
			vim.lsp.config["lua_ls"] = {
				enabled = true,
				capabilities = capabilities,
				on_attach = on_attach,
			}

			-- Bash LSP
			vim.lsp.config["bashls"] = {
				enabled = true,
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Clangd
			vim.lsp.config["clangd"] = {
				enabled = true,
				cmd = { "clangd", "--log=verbose" },
				filetypes = { "c", "cpp" },
				root_dir = vim.fs.root(0, { "Makefile", ".git", "compile_commands.json" }) or vim.fn.getcwd(),
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Python LSP with project .venv detection
			vim.lsp.config["pyright"] = {
				enabled = true,
				on_attach = on_attach,
				capabilities = capabilities,
				before_init = function(_, config)
					local venv = vim.fn.getcwd() .. "/.venv"
					if vim.fn.isdirectory(venv) == 1 then
						config.settings = config.settings or {}
						config.settings.python = config.settings.python or {}
						config.settings.python.pythonPath = venv .. "/bin/python"
					end
				end,
			}

			-- Automatically start enabled LSPs
			for server, config in pairs(vim.lsp.config) do
				if config.enabled then
					vim.lsp.start(config)
				end
			end
		end,
	},
}
