return{
{
	"echasnovski/mini.nvim",
	version = false, -- always use latest
	enabled = false, -- 			Temporary disable this module
  config = function()
	  require("mini.files").setup({
		  mappings = {
			  close = "q",
			  go_in = "l",
			  go_out = "h",
			  reset = "<BS>",
			  reveal_cwd = "@",
			  show_help = "g?",
      },
    })

    require("mini.comment").setup()
    require("mini.statusline").setup()
    -- Add more modules as needed
  end,
}

}

