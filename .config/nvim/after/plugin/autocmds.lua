local api = vim.api
local augroup = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

local patronus = augroup("patronus", {clear=true})
-- packer compile
augroup("packer", { clear = true })
cmd("BufWritePost", {
    desc = "Sync packer after modifying plugins.lua",
    group = "packer",
    pattern = "*/nvim/lua/plugins/init.lua",
    command = "source <afile> | PackerSync",
})

-- override for all filetypes
cmd("FileType", {
    command = "setlocal formatoptions-=cro",
})

-- terminals
cmd("TermOpen", {
    callback = function()
        -- disable line numbers
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        -- always start in insert mode
        vim.cmd("startinsert")
    end,
})

-- highlight on yank
cmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Reload buffer if it is changed outside of vim
cmd({ 'FocusGained', 'BufEnter' }, {
  pattern = '*',
  command = [[silent! exe 'checktime']],
  group = patronus,
})

-- turn off signcolumn for orgagenda
-- cmd("FileType", {
--     pattern = "orgagenda",
--     callback = function()
--         vim.opt.signcolumn = "no"
--         vim.opt.relativenumber = true
--     end
-- })


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
