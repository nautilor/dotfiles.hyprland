-- glj -> insert log below
-- glk -> insert log above
-- glo -> insert plain log below
-- glp -> insert plain log above (fake but possible)
-- gla -> add a log target to the batch
-- glc -> print the batch

return {
	"Goose97/timber.nvim",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("timber").setup({
			-- Configuration here, or leave empty to use defaults
		})
	end
}
