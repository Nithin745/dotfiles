local rt = require("rust-tools")
local M = {}

M.setup = function(on_attach, capabilities, on_init)
    rt.setup({
        tools = {
            on_initialized = function(result)
                vim.cmd([[
                  augroup SuperDuperAus
                    autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                    autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                    autocmd BufWritePre                     *.rs silent! lua vim.lsp.buf.formatting_sync()
                  augroup END
                ]])
            end,
        },
        server = {
            -- on_attach = function(_, bufnr)
            --     -- Hover actions
            --     vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            --     -- Code action groups
            --     vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            -- end,
            cmd = { "rustup", "run", "nightly", "rust-analyzer" },
            on_attach = on_attach,
            capabilities = capabilities,
            on_init = on_init,
            settings = {
                ["rust-analyzer"] = {
                    unstable_features = true,
                    build_on_save = false,
                    all_features = true,
                    checkOnSave = {
                        -- enable = true,
                        command = "clippy"
                    },
                    diagnostics = {
                        enable = true,
                        experimental = {
                            enable = true
                        }
                    },
                    assist = {
                        importGranularity = "module",
                        importPrefix = "by_self",
                    },
                    cargo = {
                        loadOutDirsFromCheck = true
                    },
                    procMacro = {
                        enable = true
                    },
                },
            }
        },
    })
end

return M
