local keymap = vim.keymap
local opts = { remap = true, silent = true }
local nopts = { noremap = true, silent = true }
local term_opts = { silent = true }

local function smart_close()
	if #vim.api.nvim_list_wins() > 1 then
		vim.cmd("close")
	else
		vim.cmd("bd!")
	end
end

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable F1 & q
keymap.set("n", "q", "")
keymap.set({ "n", "i" }, "<F1>", "")

-- Terminal esc key
keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Better paste without overwriting clipboard
keymap.set("x", "p", '"_dP')
keymap.set({ "n", "v" }, "x", '"_x', nopts)

-- System clipboard
keymap.set({ "n", "x" }, "<C-y>", '"+y', nopts)
keymap.set("n", "<C-p>", "\"+p", nopts)
keymap.set("v", "<C-p>", '"_d"+P', nopts)
keymap.set("x", "<C-p>", '"_d"+P', nopts)

-- Save
keymap.set("n", "<C-s>", ":w<Return>")
keymap.set("i", "<C-s>", "<Esc>:w<Return>a")
keymap.set("v", "<C-s>", "<Esc>:w<Return>gv")

-- Select all
keymap.set({ "n", "x" }, "<C-a>", "gg<S-v>G")
keymap.set("i", "<C-a>", "<Esc>gg<S-v>G")

-- Quit insert mode quickly
keymap.set("i", "jk", "<Esc>")

-- Close buffer/window
keymap.set("n", "<leader>q", ":q<Return>", nopts)
keymap.set("n", "<leader><C-q>", ":q!<Return>", nopts)

-- Move X lines when using shift+down/up
keymap.set({ "n", "v" }, "<S-Down>", "3j", opts)
keymap.set({ "n", "v" }, "<S-Up>", "3k", opts)

-- Comment code
keymap.set("n", "<C-_>", "gcc", opts)
keymap.set("x", "<C-_>", "gc", opts)
keymap.set("n", "<C-/>", "gcc", opts)
keymap.set("x", "<C-/>", "gc", opts)

-- Tabs
keymap.set("n", "<tab>", ":bnext<Return>", nopts)
keymap.set("n", "<S-tab>", ":bprev<Return>", nopts)
keymap.set("n", "<leader>bd", ":bd!<Return>", nopts)

-- Reset the last search highlight
keymap.set("n", "<leader>/", ":nohlsearch<Return>", nopts)

-- Code Diff current File
keymap.set("n", "<leader>gd", ":CodeDiff file HEAD<Return>", nopts)

-- Split
keymap.set("n", "sv", ":split<Return>", nopts)
keymap.set("n", "ss", ":vsplit<Return>", nopts)
keymap.set("n", "wd", "<C-w><C-w>", opts)
keymap.set("n", "sd", smart_close, nopts)
keymap.set("n", "sk", ":bp | bd #<Return>", nopts)
keymap.set("n", "<C-w><C-d>", "<C-w>q", nopts)
keymap.set("n", "<C-w><C-d>", ":bp | bd #<Return>", nopts)
keymap.set("n", "<C-w><C-j>", function() require("tmux").move_right() end, nopts)
keymap.set("n", "<C-w><C-i>", function() require("tmux").move_top() end, nopts)
keymap.set("n", "<C-w><C-k>", function() require("tmux").move_bottom() end, nopts)
keymap.set("n", "<C-w><C-l>", function() require("tmux").move_left() end, nopts)

-- Diagnostic
keymap.set("n", "<C-j>", vim.diagnostic.goto_next, nopts)

-- LazyGit
keymap.set("n", "<C-l>", ":LazyGit<Return>", nopts)

-- Go back and forward from jumps
keymap.set("n", "<C-w>b", "<C-o>", nopts)
keymap.set("n", "<C-w>f", "<C-i>", nopts)

-- Snacks Picker
keymap.set({ "i", "n" }, "<C-o>", function() require("snacks").picker.files() end, nopts)
keymap.set({ "i", "n" }, "<C-f>", function() require("snacks").picker.grep() end, nopts)
keymap.set("n", "<leader>bb", function() require("snacks").picker.buffers() end, nopts)

-- LSP
keymap.set("n", "gd", function() require("snacks").picker.lsp_definitions() end, nopts)
keymap.set("n", "gf", function() require("snacks").picker.lsp_references() end, nopts)
keymap.set("n", "<leader>r", vim.lsp.buf.rename)
keymap.set({ "n", "i" }, "<F2>", vim.lsp.buf.rename)

-- Snacks Zen
keymap.set("n", "<C-z>", function() require("snacks").zen() end, nopts)

-- ToggleTerm
keymap.set({ "n", "x", "t", "i" }, "<C-t>", "<cmd>ToggleTerm direction=float<Return>", nopts)

-- NvimTree
keymap.set("n", "<leader>e", ":NvimTreeToggle<Return>", nopts)
keymap.set({ "i", "n" }, "<C-b>", ":NvimTreeToggle<Return>", nopts)

-- Obsidian
keymap.set("n", "<leader>os", ":Obsidian quick_switch<CR>")
keymap.set("n", "<leader>on", ":Obsidian new<CR>")
keymap.set("n", "<leader>oo", ":cd ~/.obsidian/Notes/<CR>")
vim.api.nvim_create_autocmd("User", {
	pattern = "ObsidianNoteEnter",
	callback = function()
		keymap.set("n", "<leader>oc", ":Obsidian toggle_checkbox<CR>")
	end
})
