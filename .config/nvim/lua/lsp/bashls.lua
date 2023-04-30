local M = {}

M.setup = function(on_attach, capabilities, after_init)
    require("lspconfig").bashls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- after_init = after_init
    })
end

return M

