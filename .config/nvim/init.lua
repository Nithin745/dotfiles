local api = vim.api
local u = require("config.utils")

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.g.ruvbox_material_better_performance = 1
-- vim.g.gruvbox_material_transparent_background = 1
vim.g.do_filetype_lua = 1
vim.o.timeoutlen = 300

-- neon colorscheme
-- vim.g.neon_style = "doom"
-- vim.g.neon_italic_keyword = true
-- vim.g.neon_italic_function = true
-- vim.g.neon_transparent = true

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.pumheight = 10
vim.opt.ignorecase = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.updatetime = 100
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 2
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.timeoutlen = 1000
vim.opt.shortmess:append("cA")
vim.opt.clipboard:append("unnamedplus")
vim.opt.autoindent = true
vim.opt.shell = "/bin/sh"
vim.opt.diffopt = "vertical"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME/.vim/undo")
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_tmp_query_location = vim.fn.expand("$HOME/.cache/queries/tmp")
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_auto_execute_table_helpers = 0
-- vim.g.db_ui_save_location = vim.fn.expand("$HOME/.cache/queries")
-- vim.g.db_ui_debug = 0
-- vim.opt.statusline = [[%f %y %m %= %p%% %l:%c]]

-- tabs
u.nmap("<LocalLeader>t", ":tabnew<CR>")
u.nmap("<LocalLeader>x", ":tabclose<CR>")
u.nmap("<LocalLeader>o", ":tabonly<CR>")
u.nmap("<LocalLeader>e", function()
    local start_tab = api.nvim_tabpage_get_number(0)

    vim.cmd("tabedit %")
    local new_tab = api.nvim_tabpage_get_number(0)

    vim.cmd(string.format("%dtabdo b#", start_tab))
    vim.cmd(string.format("normal %dgt", new_tab))
end)
u.nmap("<LocalLeader>v", ":vsplit %<CR>")
u.nmap("<LocalLeader>s", ":split %<CR>")

-- insert clipboard content without messing up indentation
u.imap("<C-;>", "<C-r><C-p>*")
u.cmap("<C-;>", "<C-r><C-p>*")

-- source remaining config
require("impatient")
require("plugins")
require("config")
require('luatab').setup{}
require("lsp")
