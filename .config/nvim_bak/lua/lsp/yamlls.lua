local util = require('lspconfig/util')

local M = {}

M.setup = function(on_attach, capabilities, after_init)
    require("lspconfig").yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

return M
