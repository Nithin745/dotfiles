---@type ChadrcConfig
local M = {}
local api = vim.api
local fn = vim.fn

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

local isBufValid = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

local check_filename = function(name, bufnr)
  local maxname_len = 16
  for _, value in ipairs(vim.api.nvim_list_bufs()) do
    if isBufValid(value) then
      if name == fn.fnamemodify(api.nvim_buf_get_name(value), ":t") and value ~= bufnr then
        local other = {}
        for match in (vim.fs.normalize(api.nvim_buf_get_name(value)) .. "/"):gmatch("(.-)" .. "/") do
          table.insert(other, match)
        end

        local current = {}
        for match in (vim.fs.normalize(api.nvim_buf_get_name(bufnr)) .. "/"):gmatch("(.-)" .. "/") do
          table.insert(current, match)
        end

        name = current[#current]

        for i = #current - 1, 1, -1 do
          local value_current = current[i]
          local other_current = other[i]

          if value_current ~= other_current then
            if (#current - i) < 2 then
              name = value_current .. "/" .. name
            else
              name = value_current .. "/../" .. name
            end
            break
          end
        end
        break
      end
    end
    return (#name > maxname_len and string.sub(name, 1, 14) .. "..") or name
  end
end
M.ui = {
  theme = "gruvbox",
  theme_toggle = { "gruvbox", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens
  tabufline = {
    lazyload = true,
    overriden_modules = function(modules)
      modules[2] = (function()
        return ""
      end)()
      table.insert(
        modules,
        3,
        (function()
          local result, number_of_tabs = "", fn.tabpagenr "$"
          local icon = " 󰈚 "

          if number_of_tabs > 0 then
            for i = 1, number_of_tabs, 1 do
              local filename = fn.bufname(fn.tabpagebuflist(i)[1])
              local buftype = fn.getbufvar(fn.tabpagebuflist(i)[1], "&ft")
              if filename == "" then
                filename = "Empty "
              else
                -- local current_tabnr = vim.api.nvim_get_current_tabpage()
                local buffer_numbers = vim.fn.tabpagebuflist(i)
                for _, bufnr in ipairs(buffer_numbers) do
                  -- Get the filename
                  local _filename = vim.api.nvim_buf_get_name(bufnr)
                  -- Get the buffer type (filetype)
                  local _buftype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                  if _buftype ~= "NvimTree" then
                    filename = _filename
                    local devicons = require "nvim-web-devicons"
                    -- local name = (#api.nvim_buf_get_name(bufnr) ~= 0) and fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":t") or " No Name "
                    filename = fn.fnamemodify(filename, ":t")
                    -- filename = check_filename(name, bufnr)
                    local ft_icon = devicons.get_icon(filename)
                    icon = (ft_icon ~= nil and " " .. ft_icon) or ""
                    -- local modified = fn.getbufvar(fn.tabpagebuflist(i)[1], "&mod")
                    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
                    if modified then
                      filename = filename .. "  "
                    else
                      filename = filename .. " "
                    end
                    break
                  end
                end
              end
              local tab_hl = ((i == fn.tabpagenr()) and "%#TbLineTabOn# ") or "%#TbLineTabOff# "
              result = result .. ("%" .. i .. "@TbGotoTab@" .. tab_hl .. i .. icon .. " " .. filename)
              result = (i == fn.tabpagenr() and result .. "%#TbLineTabCloseBtn#" .. "%@TbTabClose@󰅙 %X") or result
            end

            local new_tabtn = "%#TblineTabNewBtn#" .. "%@TbNewTab@  %X"
            local tabstoggleBtn = ""
            return vim.g.TbTabsToggled == 1 and tabstoggleBtn:gsub("()", { [36] = " " })
              or new_tabtn .. tabstoggleBtn .. result
          end
        end)()
      )
      table.insert(modules, 4, (function ()
        return "%#TblineFill#%="
      end)())
    end,
  },
}

M.plugins = "custom.plugins"
require "custom.configs.keymaps"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
