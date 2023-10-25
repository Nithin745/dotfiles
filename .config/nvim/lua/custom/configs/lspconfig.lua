local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local custom_utils = require("custom.configs.utils")
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local lspconfig = require "lspconfig"

-- default custom_init
local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end



-- function to setup server
local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  lspconfig[server].setup(config)
end
-- if you just want default config for the servers then put them in a table
local servers = {
  pyright = {
    cmd = { "pyright-langserver", "--stdio" }, --watch
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          stubPath = "typings",
          autoImportCompletions = false,
          diagnosticMode = "workspace",
        },
      },
    },
    -- after_init = after_init,
    before_init = function(_, config)
      config.settings.python.pythonPath = custom_utils.get_python_path(config.root_dir)
    end,
    single_file_support = true,
  }
}

for server, config in pairs(servers) do
  setup_server(server, config)
end
