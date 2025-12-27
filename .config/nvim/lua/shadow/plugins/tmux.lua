return ({
	"aserowy/tmux.nvim",
	config = function()
		return require("tmux").setup({
			navigation = {
				cycle_navigation = true,
			}
		})
	end
})
