-- Set leader early
vim.g.mapleader = " "

-- Now it's safe to map keys using <leader>
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--vim.keymap.set("n", "<leader>fd", require("telescope.buildin").find_files)
vim.keymap.set(
	"n",
	"<leader>fs",
	':!make && openocd -f .openocd.cfg -c "program dexx-diversity.elf verify reset exit"<CR>'
)
