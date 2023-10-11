local util = require('lspconfig/util')

local M = {}

M.setup = function(on_attach, capabilities, after_init)
    require("lspconfig").emmet_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {'html', 'django-html', 'htmldjango', "typescriptreact", "javascriptreact", "css", "sass", "scss", "less"},
        -- after_init = after_init
    })
end

return M

