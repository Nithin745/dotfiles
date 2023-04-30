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
      useLibraryCodeForTypes = true,
      stubPath = "typings",
      autoImportCompletions = false,
      diagnosticMode = "workspace"
    },
  },
}

local M = {}

M.setup = function(on_attach, capabilities, after_init)
  require("lspconfig").pyright.setup({
    cmd = { "pyright-langserver", "--stdio"}, -- --watch
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings,
    -- after_init = after_init,
    before_init = function(_, config)
      config.settings.python.pythonPath = get_python_path(config.root_dir)
    end,
    single_file_support = true,
  })
end

return M
