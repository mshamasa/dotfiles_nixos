-- mapleader must be set before lazy loads
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

require("defaults")
require("mappings")
require("comp_settings")
require("formatter")
require("lsp_settings")
require("other_settings")
require("telescope_settings")

vim.g.NERDTreeGitStatusWithFlags = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeIgnore = { "^node_modules$" }

vim.g.ackprg = "rg --vimgrep --smart-case"
vim.g.ack_use_cword_for_empty_search = 1

vim.cmd.colorscheme("tokyonight-storm")
