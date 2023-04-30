local servers = {
  "cssls",
  "cssmodules_ls",
  "emmet_ls",
  "html",
  "jsonls",
  "lua_ls",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "dockerls",
  -- "rust_analyzer"
}

local settings = {
  ensure_installed = servers
}

require("mason-lspconfig").setup(settings)
