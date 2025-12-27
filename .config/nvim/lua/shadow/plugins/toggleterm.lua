return {
	'akinsho/toggleterm.nvim',
	version = "*",
	opts = {
		shade_terminal = false,
		highlights = {
			NormalFloat = {
				link = "ToggleTermNormal"
			},
			NormalBorder = {
				link = "ToggleTermBorder"
			}
		},
		float_opts = {
			border = "curved",
		}
	}
}
