local util = require('lspconfig/util')

local M = {}

M.setup = function(on_attach, capabilities, after_init )
    require("lspconfig").sqlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- after_init = after_init,
        single_file_support = true,
    })
end

return M

