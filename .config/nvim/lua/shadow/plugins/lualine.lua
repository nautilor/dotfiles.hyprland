local mocha = require("catppuccin.palettes").get_palette "mocha"

local catppuccin_theme = {
	normal = {
		a = { fg = mocha.surface0, bg = mocha.mauve, gui = "bold" },
		b = { fg = mocha.text, bg = mocha.surface1 },
		c = { fg = mocha.text, bg = mocha.surface0 },
	},
	insert = {
		a = { fg = mocha.surface0, bg = mocha.blue, gui = "bold" },
		b = { fg = mocha.text, bg = mocha.surface1 },
		c = { fg = mocha.text, bg = mocha.surface0 },
	},
	visual = {
		a = { fg = mocha.surface0, bg = mocha.teal, gui = "bold" },
		b = { fg = mocha.text, bg = mocha.surface1 },
		c = { fg = mocha.text, bg = mocha.surface0 },
	},
	replace = {
		a = { fg = mocha.surface0, bg = mocha.red, gui = "bold" },
		b = { fg = mocha.text, bg = mocha.surface1 },
		c = { fg = mocha.text, bg = mocha.surface0 },
	},
	command = {
		a = { fg = mocha.surface0, bg = mocha.yellow, gui = "bold" },
		b = { fg = mocha.text, bg = mocha.surface1 },
		c = { fg = mocha.text, bg = mocha.surface0 },
	},
	inactive = {
		a = { fg = mocha.surface0, bg = mocha.surface1, gui = "bold" },
		b = { fg = mocha.text, bg = mocha.surface1 },
		c = { fg = mocha.text, bg = mocha.surface0 },
	},
}

return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	init = function()
		vim.opt.laststatus = 3
	end,
	opts = {
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			theme = catppuccin_theme,
		},
		sections = {
			lualine_a = {
				{
					"mode",
					icon_enable = true,
					fmt = function()
						return vim.api.nvim_get_mode().mode == "t" and ""
								or ""
					end,
					separator = { left = "" }
				},
				{
					"mode",
					separator = { right = "" }
				}
			},
			lualine_b = {
				{
					"branch",
				},
				{
					"diff",
					separator = { right = "" }
				}
			},
			lualine_c = {
			},
			lualine_x = {
			},
			lualine_y = {
				{
					"filetype",
					icon_only = true,
					separator = { left = "" }
				},
				{ "filename", icon_only = true, },
				{ "progress", icon_only = true, },
			},
			lualine_z = {
				{
					"selectioncount",
					fmt = function(count)
						if count == "" then
							return ""
						end
						return "[" .. count .. "]"
					end,
				},
				{
					"location",
					fmt = function(location)
						return location:gsub("%s+", "")
					end,
					separator = { right = "", left = "" }
				},
			},
		},
		inactive_sections = {
			lualine_a = {
				{ "filename" },
			},
			lualine_b = {
			},
			lualine_c = {},
			lualine_x = {},
			lualine_z = { "location" },
		},
	}
}

-- 	rosewater = "#f5e0dc",
-- 	flamingo = "#f2cdcd",
-- 	pink = "#f5c2e7",
-- 	mauve = "#cba6f7",
-- 	red = "#f38ba8",
-- 	maroon = "#eba0ac",
-- 	peach = "#fab387",
-- 	yellow = "#f9e2af",
-- 	green = "#a6e3a1",
-- 	teal = "#94e2d5",
-- 	sky = "#89dceb",
-- 	sapphire = "#74c7ec",
-- 	blue = "#89b4fa",
-- 	lavender = "#b4befe",
-- 	text = "#cdd6f4",
-- 	surface0 = "#313244",
-- 	base = "#1e1e2e",
-- 	mantle = "#181825",
-- 	crust = "#11111b",
