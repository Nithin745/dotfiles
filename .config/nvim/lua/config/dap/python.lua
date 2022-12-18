local dap = require('dap')
local util = require('lspconfig/util')
local python_dap = require('dap-python')
local u = require("config.utils")


local python_path = function()
  -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
  -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
  -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
    return cwd .. '/venv/bin/python'
  elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
    return cwd .. '/.venv/bin/python'
  elseif vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  else
      -- Fallback to system Python.
      return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
  end
end;

python_dap.setup('~/.pyenv/versions/neovim/bin/python')


table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'django',
  program = '${workspaceFolder}/manage.py',
  django = false,
  console = 'internalConsole',
  justMyCode = true,
  args ={'runserver', '--noreload'},
  env = {PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT="2"},
  -- python = python_path()
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'django_command',
  program = '${workspaceFolder}/manage.py',
  django = false,
  console = 'internalConsole',
  justMyCode = false,
  -- args = {'ingest', '--member', '--folder_name', '1/1/provider', '--filename', 'member.csv'},
  -- args = {'charts', '--project', '1', '--client', '1'},
  env = {PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT="2"},
  args = function ()
    local default_value = {'ingest', '--provider', '--folder_name', '1/1/provider', '--filename', 'provider.csv', '--dry_run'}
    local args = vim.fn.input('Command: ')
    return vim.split(args, ' +')
  end
  -- python = python_path()
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})
u.nmap("<leader>dn", ":lua require('dap-python').test_method()<CR>")
