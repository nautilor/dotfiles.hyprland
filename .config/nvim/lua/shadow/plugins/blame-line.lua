return {
	"f-person/git-blame.nvim",
	event = "BufReadPre",
	config = function()
		require("gitblame").setup({
			enabled = true,
			date_format = "%Y-%m-%d",
		})
	end,
}
