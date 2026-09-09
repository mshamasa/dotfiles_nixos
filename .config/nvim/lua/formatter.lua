require("conform").setup({
	formatters = {
		biome = {
			require_cwd = true,
		},
		prettier = {
			require_cwd = true,
		},
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		-- Conform will run multiple formatters sequentially
		go = { "goimports" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt" },
		-- Conform will run the first available formatter
		javascript = { "biome", "prettier", stop_after_first = true },
		json = { "biome", "prettier", stop_after_first = true },
		typescript = { "biome", "prettier", stop_after_first = true },
		typescriptreact = { "biome", "prettier", stop_after_first = true },
		yaml = { "prettier", stop_after_first = true },
		python = { "isort", "black" },
		zig = { "zigfmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
	},
})
