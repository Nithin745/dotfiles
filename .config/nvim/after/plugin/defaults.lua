local g = vim.g
-- local transparent_groups = { 'Normal', 'Comment', 'Constant', 'Special', 'Identifier',
--     'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'CursorLine',
--     'Function', 'Conditional', 'Repeat', 'Operator', 'Structure', 'PmenuSel', 'PmenuSel', 'PmenuThumb',
--     'LineNr', 'NonText', 'SignColumn', 'CursorLineNr', 'EndOfBuffer', 'Pmenu', 'Float', 'FloatNormal'}
vim.cmd "colorscheme gruvbox-material"
-- for _, group in ipairs(transparent_groups) do
--     vim.api.nvim_set_hl(0, group, {bg="none", fg="none"})
-- end
-- vim.api.nvim_set_hl(0, "Normal", {bg="none"})
-- vim.api.nvim_set_hl(0, "NormalFloat", {bg="none"})
-- vim.api.nvim_set_hl(0, "CursorLine", {bg="none"})
-- vim.api.nvim_set_hl(0, "NonText", {bg="none"})
-- vim.api.nvim_set_hl(0, "EndOfBuffer", {bg="none"})
-- vim.api.nvim_set_hl(0, "Folded", {bg="none"})
-- vim.api.nvim_set_hl(0, "LineNr", {bg="none"})
-- vim.api.nvim_set_hl(0, "SpecialKey", {bg="none"})
-- vim.api.nvim_set_hl(0, "SignColumn", {bg="none"})
-- vim.api.nvim_set_hl(0, "VertSplit", {bg="none"})

g.node_host_prog = "$HOME/.nvm/versions/node/v18.12.1/bin/neovim-node-host"
g.loaded_python_provider = 0
g.python3_host_prog = "$HOME/.pyenv/versions/neovim/bin/python"
g.loaded_ruby_provider = 0
g.loaded_perl_provider  = 0
