return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	-- set colorscheme
	config = function(_, opts)
		require("catppuccin").setup({
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha"
			},
			custom_highlights = function(colors)
				return {
					-- Usa lo stesso bg di Telescope
					ToggleTermNormal = { link = "TelescopeNormal" },
					ToggleTermBorder = { link = "TelescopeBorder" },
				}
			end,
			transparent_background = true,
			float = {
				transparent = true, -- enable transparent floating windows
				solid = true,   -- use solid styling for floating windows, see |winborder|
			},
		})
		vim.cmd.colorscheme "catppuccin"
	end
}
