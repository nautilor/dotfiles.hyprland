return {
	'neovim/nvim-lspconfig',
	dependencies = { 'saghen/blink.cmp' },
	config = function()
		vim.lsp.enable({
			"pyright",
			"ts_ls",
			"eslint",
			"clangd",
			"lua_ls",
			"jdtls",
			"vscode_spring_boot_tools",
			"copilot_language_server"
		})
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" } }
				}
			}
		})
	end
}
