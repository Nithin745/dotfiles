local util = require('lspconfig/util')

local M = {}

M.setup = function(on_attach, capabilities)
    require("lspconfig").html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {'css', 'scss', 'less', 'html', 'django-html', 'htmldjango'},
    })
end

return M

