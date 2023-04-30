local rt = require("rust-tools")
local M = {}

M.setup = function(on_attach, capabilities, on_init)
  rt.setup({
    -- tools = {
    --   on_initialized = function(_)
    --   end,
    -- },
    server = {
      -- on_attach = function(_, bufnr)
      --     -- Hover actions
      --     vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      --     -- Code action groups
      --     vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      -- end,
      cmd = { "rustup", "run", "stable", "rust-analyzer" },
      on_attach = on_attach,
      capabilities = capabilities,
      -- after_init = on_init,
      settings = {
        ["rust-analyzer"] = {
          inlayHints = { locationLinks = false },
          unstable_features = true,
          build_on_save = false,
          all_features = true,
          checkOnSave = {
            -- enable = true,
            command = "clippy",
          },
          diagnostics = {
            enable = true,
            experimental = {
              enable = true,
            },
          },
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            allFeatures = true
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  })
end

-- local alt_key_mappings = {
--     {"code_lens", "n", "<leader>lcld","<Cmd>lua vim.lsp.codelens.refresh()<CR>"},
--     {"code_lens", "n", "<leader>lclr", "<Cmd>lua vim.lsp.codelens.run()<CR>"}
-- }
--
-- local function set_lsp_config(client, bufnr)
--     require"lsp_signature".on_attach({
--         bind = true,
--         handler_opts = {border = "single"}
--     })
--
--     local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(...) end
--     local function buf_set_option(...) vim.api.nvim_buf_set_option(...) end
--
--     buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--     for _, mappings in pairs(alt_key_mappings) do
--         local capability, mode, lhs, rhs = unpack(mappings)
--         if client.resolved_capabilities[capability] then
--             buf_set_keymap(bufnr, mode, lhs, rhs, opts)
--         end
--     end
--
-- end
return M
