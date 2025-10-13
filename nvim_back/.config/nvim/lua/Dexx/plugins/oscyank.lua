return {
{
  "ojroques/vim-oscyank",
  config = function()
    vim.g.oscyank_max_length = 100000
    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function()
        if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
          vim.cmd("OSCYankReg +")
        end
      end,
    })
  end,
}
}