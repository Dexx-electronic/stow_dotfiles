# Disable banner
vim.cmd("let g:netrw_banner = 0")

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.undofile = true

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})

vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
}
