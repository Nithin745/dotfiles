local util = require('lspconfig/util')

local M = {}

M.setup = function(on_attach, capabilities)
    require("lspconfig").rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
    })
end

return M

