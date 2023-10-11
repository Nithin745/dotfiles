local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local settings = {
  Lua = {
    format = {
      enable = false,
      -- Put format options here
      -- NOTE: the value should be STRING!!
      defaultConfig = {
        indent_style = "space",
        indent_size = "2",
      },
    },
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = "LuaJIT",
      -- Setup your lua path
      path = runtime_path,
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
      ignoreDir = { ".git" },
      library = vim.api.nvim_get_runtime_file("", true),
      -- maxPreload = 2000,
      -- preloadFileSize = 20000,
    },
    completion = { callSnippet = "Replace" },
    telemetry = { enable = false },
    hint = {
      enable = true,
    },
  },
}

local M = {}

M.setup = function(on_attach, capabilities, after_init)
  require("neodev").setup({})
  local lspconfig = require("lspconfig")
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings,
    -- after_init = after_init,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

return M
