local M = {}

-- local tbl_insert = table.insert
-- local log = require("plenary.log").new({
--   plugin = "nithin",
--   level = "debug",
-- })

local get_map_options = function(custom_options)
  local options = { silent = true }
  if custom_options then
    options = vim.tbl_extend("force", options, custom_options)
  end
  return options
end
M.map = function(mode, target, source, opts)
  vim.keymap.set(mode, target, source, get_map_options(opts))
end

for _, mode in ipairs({ "n", "o", "i", "x", "t", "c", "v" }) do
  M[mode .. "map"] = function(...)
    M.map(mode, ...)
  end
end


-- default to black hole register
M.nmap("d", '"_d')
M.xmap("d", '"_d')
M.nmap("dd", '"_dd')
M.nmap("D", '"_D')

M.nmap("c", '"_c')
M.xmap("c", '"_c')
M.nmap("cc", '"_cc')
M.nmap("C", '"_C')

M.nmap("x", '"_x')
M.xmap("x", '"_x')
M.nmap("X", '"_X')

M.nmap("m", "d")
M.xmap("m", "d")
M.nmap("mm", "dd")
M.nmap("M", "D")
