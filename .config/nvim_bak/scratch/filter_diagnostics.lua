local unused
unused = nothing

bufnr = vim.api.nvim_get_current_buf()

local set_diagnostics_level = function()
  local diagnostics = vim.diagnostic.get(bufnr)
  print(vim.inspect(diagnostics))
end

set_diagnostics_level()
