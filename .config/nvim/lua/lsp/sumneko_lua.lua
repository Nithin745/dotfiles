local settings = {
    Lua = {
        runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
            -- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            -- library = {
            --     [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            --     [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            --     ["${3rd}/love2d/library"] = true,
            -- },
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true),
            maxPreload = 2000,
            preloadFileSize = 20000,
        },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        hint = {
            enable = true,
        },
    },
}

local M = {}

M.setup = function(on_attach, capabilities)
    require("neodev").setup({})
    local lspconfig = require('lspconfig')
    lspconfig.sumneko_lua.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = settings,
        flags = {
            debounce_text_changes = 150,
        }
    })
end

return M
