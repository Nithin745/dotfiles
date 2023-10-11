local api = vim.api
local augroup = vim.api.nvim_create_augroup

local patronus = augroup("patronus", { clear = true })
-- packer compile
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Sync packer after modifying plugins.lua",
  group = patronus,
  pattern = "*/nvim/lua/plugins/init.lua",
  command = "source <afile> | PackerSync",
})

-- override for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  command = "setlocal formatoptions-=cro",
  group = patronus,
})

-- Non editable buffer options
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "Jaq", "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "DressingSelect", "tsplayground" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
  group = patronus,
})

-- terminals TermOpen
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "term://*" },
  callback = function()
    -- disable line numbers
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    -- always start in insert mode
    vim.cmd("startinsert")
    vim.cmd("set cmdheight=1")
  end,
  group = patronus,
})

-- Enable spellcheck on gitcommit and markdown
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "org" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = patronus,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  group = patronus,
})

-- Reload buffer if it is changed outside of vim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = [[silent! exe 'checktime']],
  group = patronus,
})

-- turn off signcolumn for dap-repl
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    vim.opt_local.signcolumn = "no"
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    -- vim.opt.number = false
    -- vim.opt.relativenumber = false
  end,
  group = patronus,
})

-- Strip trailing spaces before write
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[ %s/\s\+$//e ]])
  end,
  group = patronus,
})

vim.cmd([[
    " Have Vim jump to the last position when reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""
    endif
]])

-- Toggle hlsearch
-- api.nvim_command([[nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()]])

-- Disable status
-- local disable_status = augroup("Disable_status", { clear= true})
-- cmd("FileType", {
--     desc = "Disable statusline for some items",
--     group = disable_status,
--     pattern= {"alpha", "nnn", "Mundo"},
--     callback = function()
--         local prev_status = vim.opt.laststatus
--         vim.opt.laststatus = 0
--         cmd("BufUnload", {
--             pattern = vim.fn.expand("<buffer>"),
--             callback = function()
--                 vim.opt.laststatus = prev_status
--             end
--         })
--     end
-- })
