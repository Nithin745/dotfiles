local dap = require "dap"
local configs = dap.configurations.python or {}
local util = require "lspconfig/util"
dap.configurations.python = configs
-- dap.set_log_level('TRACE')

local pythonPath = function()
  -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
  -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
  -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
  local cwd = vim.fn.getcwd()
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return "/usr/bin/python"
  end
end

dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb {
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
      options = {
        source_filetype = "python",
      },
    }
  else
    cb {
      type = "executable",
      command = vim.fn.expand "~/.pyenv/versions/neovim/bin/python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    }
  end
end
table.insert(configs, {
  type = "python",
  request = "launch",
  name = "launch file",
  program = "${file}",
  django = false,
  console = "internalConsole",
  justMyCode = true,
  env = { PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "20" },
  pythonPath = pythonPath,
})

table.insert(configs, {
  type = "python",
  request = "launch",
  name = "launch file with args",
  program = "${file}",
  django = false,
  console = "internalConsole",
  justMyCode = true,
  env = { PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "20" },
  args = function()
    local args = vim.fn.input "Command: "
    return vim.split(args, " +")
  end,
  pythonPath = pythonPath,
})

table.insert(configs, {
  type = "python",
  request = "launch",
  name = "django - justMyCode",
  program = "${workspaceFolder}/manage.py",
  django = true,
  console = "internalConsole",
  justMyCode = true,
  args = { "runserver", "--noreload" },
  env = { PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "20" },
  pythonPath = pythonPath,
})

table.insert(configs, {
  type = "python",
  request = "launch",
  name = "django - justMyCode=false",
  program = "${workspaceFolder}/manage.py",
  django = true,
  console = "internalConsole",
  justMyCode = false,
  args = { "runserver", "--noreload" },
  env = { PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "20" },
  pythonPath = pythonPath,
})
table.insert(configs, {
  type = "python",
  request = "launch",
  name = "django_command",
  program = "${workspaceFolder}/manage.py",
  django = true,
  console = "internalConsole",
  justMyCode = true,
  env = { PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "20" },
  args = function()
    local default_value =
    { "ingest", "--provider", "--folder_name", "1/1/provider", "--filename", "provider.csv", "--dry_run" }
    local args = vim.fn.input "Command: "
    return vim.split(args, " +")
  end,
  pythonPath = pythonPath,
})
