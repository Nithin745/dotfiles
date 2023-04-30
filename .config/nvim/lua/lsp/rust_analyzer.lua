local util = require("lspconfig/util")

local M = {}

M.setup = function(on_attach, capabilities, after_init)
  require("lspconfig").rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    -- after_init = after_init,
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
  })
end

return M
