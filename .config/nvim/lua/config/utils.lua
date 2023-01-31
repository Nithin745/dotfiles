local api = vim.api
local dapui = require("dapui")
local tbl_insert = table.insert
local log = require("plenary.log").new({
  plugin = "nithin",
  level = "debug",
})

local get_map_options = function(custom_options)
  local options = { silent = true }
  if custom_options then
    options = vim.tbl_extend("force", options, custom_options)
  end
  return options
end

local M = {}

M.map = function(mode, target, source, opts)
  vim.keymap.set(mode, target, source, get_map_options(opts))
end

for _, mode in ipairs({ "n", "o", "i", "x", "t", "c", "v" }) do
  M[mode .. "map"] = function(...)
    M.map(mode, ...)
  end
end

M.buf_map = function(bufnr, mode, target, source, opts)
  opts = opts or {}
  opts.buffer = bufnr

  M.map(mode, target, source, get_map_options(opts))
end

M.command = function(name, fn, opts)
  api.nvim_create_user_command(name, fn, opts or {})
end

M.buf_command = function(bufnr, name, fn, opts)
  api.nvim_buf_create_user_command(bufnr, name, fn, opts or {})
end

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.gfind = function(str, substr, cb, init)
  init = init or 1
  local start_pos, end_pos = str:find(substr, init)
  if start_pos then
    cb(start_pos, end_pos)
    return M.gfind(str, substr, cb, end_pos + 1)
  end
end

M.table = {
  some = function(tbl, cb)
    for k, v in pairs(tbl) do
      if cb(k, v) then
        return true
      end
    end
    return false
  end,
}

M.input = function(keys, mode)
  api.nvim_feedkeys(M.t(keys), mode or "m", true)
end

M.warn = function(msg)
  api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
end

M.is_file = function(path)
  if path == "" then
    return false
  end

  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end

M.make_floating_window = function(custom_window_config, height_ratio, width_ratio)
  height_ratio = height_ratio or 0.95
  width_ratio = width_ratio or 0.95

  local height = math.ceil(vim.opt.lines:get() * height_ratio)
  local width = math.ceil(vim.opt.columns:get() * width_ratio)
  local window_config = {
    relative = "editor",
    style = "minimal",
    border = "double",
    width = width,
    height = height,
    row = width / 2,
    col = height / 2,
  }
  window_config = vim.tbl_extend("force", window_config, custom_window_config or {})

  local bufnr = api.nvim_create_buf(false, true)
  local winnr = api.nvim_open_win(bufnr, true, window_config)
  return winnr, bufnr
end

M.get_system_output = function(cmd)
  return vim.split(vim.fn.system(cmd), "\n")
end

M.null_ls_providers = function(filetype)
  local registered = {}
  local sources_avail, sources = pcall(require, "null-ls.sources")
  if sources_avail then
    for _, source in ipairs(sources.get_available(filetype)) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        tbl_insert(registered[method], source.name)
      end
    end
  end
  return registered
end

M.null_ls_sources = function(filetype, source)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and M.null_ls_providers(filetype)[methods.internal[source]] or {}
end

-- toggle options like relativenumber
M.toggle_option = function(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

M.open_in_tab = function(element)
  local buffer = dapui.elements[element].buffer()
  vim.cmd("tabnew")
  vim.api.nvim_win_set_buf(0, buffer)
  M.get_buf_name(element)
end

M.remove_nested_key = function(t, value) --remove key based on its value
  for k, v in pairs(t) do
    if v == value then
      t[k] = nil
    elseif type(v) == "table" then
      M.remove_nested_key(v, value)
    end
  end
end

M.remove_key = function(t, key_to_remove) --remove key based on its key
  for k, v in pairs(t) do
    if type(v) == "table" then
      M.remove_key(v, key_to_remove)
    elseif k == key_to_remove then
      t[k] = nil
    end
  end
end

M.get_buf_name = function(buf_name)
  local bufs = vim.api.nvim_list_bufs()
  for i, buf in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(buf)
    vim.schedule(function()
      print(name)
    end)
    if name == buf_name then
      return buf, name
    end
  end
  return false
end

return M
