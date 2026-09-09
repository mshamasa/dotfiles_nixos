local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local util = require("lspconfig.util")

-- disable inline error
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
})

vim.o.updatetime = 250
-- display errors on hover
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			border = "rounded",
			source = "if_many",
			max_width = 120,
		})
	end,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, bufopts)
	-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	-- vim.keymap.set('n', '<space>wl', function()
	--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, bufopts)
	-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
end

vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.enable("ts_ls")

vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
			checkOnSave = true,
			check = {
				command = "clippy",
			},
		},
	},
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("biome", {
	root_dir = util.root_pattern("biome.json"),
})
vim.lsp.enable("biome")

vim.lsp.config("nil_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.enable("nil_ls")

vim.lsp.config("gopls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.enable("gopls")
