local map = vim.keymap.set

map("n", "<leader>nt", ":NERDTree<CR>", { silent = true })
map("n", "<leader>nf", ":NERDTreeFind<CR>", { silent = true })
map("n", "<leader>ps", ":Ack! ", { silent = true })
map("n", "<leader>h", ":wincmd h<CR>", { silent = true })
map("n", "<leader>j", ":wincmd j<CR>", { silent = true })
map("n", "<leader>k", ":wincmd k<CR>", { silent = true })
map("n", "<leader>l", ":wincmd l<CR>", { silent = true })

-- move visual selection up or down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
-- indent visual selection left/right
map("v", "L", ">gv")
map("v", "H", "<gv")
-- copy/paste
map("v", "<leader>cp", '"+y')
map("v", "<leader>pt", '"+p')

-- open in new tab
map("n", "gf", "<C-W>gf", { silent = true })

map("n", "<S-Left>", ":tabprevious<CR>")
map("n", "<S-Right>", ":tabnext<CR>")

-- telescope
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({}))
end)
map("n", "<leader>fg", function()
	require("telescope.builtin").live_grep(require("telescope.themes").get_dropdown({}))
end)
map("n", "<leader>fb", function()
	require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({}))
end)
map("n", "<leader>fh", function()
	require("telescope.builtin").help_tags(require("telescope.themes").get_dropdown({}))
end)
map("n", "<leader>gb", function()
	require("telescope.builtin").git_branches(require("telescope.themes").get_dropdown({}))
end)

-- diagnostics
map("n", "<leader>e", function()
	vim.diagnostic.open_float(0, { scope = "line" })
end)

-- trouble
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>")
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>")
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>")
