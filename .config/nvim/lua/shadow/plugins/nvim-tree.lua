return {
	'nvim-tree/nvim-tree.lua',
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	-- options that you will normally parse to .setup({})
	opts = {
		filters = { dotfiles = false, custom = { '.obsidian' } },
		disable_netrw = true,
		hijack_cursor = true,
		sync_root_with_cwd = true,
		actions = { open_file = { quit_on_open = true } },
		update_focused_file = {
			enable = true,
			update_root = false,
		},
		renderer = {
			root_folder_label = false,
			highlight_git = true,
			indent_markers = { enable = true },
			icons = {
				glyphs = {
					default = "󰈚",
					folder = {
						default = "",
						empty = "",
						empty_open = "",
						open = "",
						symlink = "",
					},
					git = { unmerged = "" },
				},
			},
		}
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)
	end
}
