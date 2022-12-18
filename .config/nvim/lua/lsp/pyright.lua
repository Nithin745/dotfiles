local util = require('lspconfig/util')

local get_python_path = function(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({ '*', '.*' }) do
    local match = vim.fn.glob(util.path.join(workspace, pattern, 'pyenv.cfg'))
    if match ~= '' then
      return util.path.join(util.path.dirname(match),
        'bin', 'python')
    end
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

local settings = {
  python = {
    analysis = {
      typeCheckingMode = "off",
      autoSearchPaths = true,
      useLibraryCodeForTypes = false,
      autoImportCompletions = false,
      diagnosticMode = true
    },
  },
}

local M = {}

M.setup = function(on_attach, capabilities)
  require("lspconfig")['pyright'].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings,
    before_init = function(_, config)
      config.settings.python.pythonPath = get_python_path(config.root_dir)
    end,
    single_file_support = true,
  })
end

return M
