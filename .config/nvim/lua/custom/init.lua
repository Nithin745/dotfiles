local opt = vim.opt
local g = vim.g
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local patronus = augroup("patronus", { clear = true })

-- highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
  group = patronus,
})

-- Strip trailing spaces before write
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd [[ %s/\s\+$//e ]]
  end,
  group = patronus,
})

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

opt.swapfile = false
opt.undofile = true
opt.relativenumber = true
opt.undodir = vim.fn.expand "$HOME/.vim/undo"
opt.listchars = { trail = "", tab = "", nbsp = "_", extends = ">", precedes = "<" } -- highlight
opt.wildmenu = true -- wildmenu
opt.scrolloff = 8
-- opt.updatetime = 100
g.loaded_python_provider = 0
g.loaded_python3_provider = 1
g.python3_host_prog = "$HOME/.pyenv/versions/neovim/bin/python"
