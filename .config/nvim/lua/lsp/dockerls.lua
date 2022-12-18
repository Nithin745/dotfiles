local util = require('lspconfig/util')

local M = {}

M.setup = function(on_attach, capabilities)
    require("lspconfig").dockerls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- filetypes = {'html', 'django-html', 'htmldjango'},
    })
end

return M

