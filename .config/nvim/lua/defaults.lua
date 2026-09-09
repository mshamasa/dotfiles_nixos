vim.cmd("syntax on")

vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.nvim/undodir")
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.showmode = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cmdheight = 2
vim.opt.shortmess:append("c")
vim.opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "lightgrey" })
vim.opt.background = "dark"
