local M = {}
local util = require "lspconfig/util"

M.get_python_path = function(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs { "*", ".*" } do
    local match = vim.fn.glob(util.path.join(workspace, pattern, "pyenv.cfg"))
    if match ~= "" then
      return util.path.join(util.path.dirname(match), "bin", "python")
    end
  end

  -- Fallback to system Python.
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

M.close_current_window = function(buf_delete)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  local current_tab = vim.api.nvim_get_current_tabpage()

  -- Check if the current window is a split
  if #vim.api.nvim_tabpage_list_wins(current_tab) > 1 then
    -- Remove the buffer from the buffer list
    if buf_delete then
      vim.api.nvim_buf_delete(current_buf, { force = true })
    end
    vim.api.nvim_win_close(current_win, true)
  else
    -- If it's the last window in the tab, close the tab
    vim.api.nvim_tabpage_close(current_tab, true)
  end
end

return M
