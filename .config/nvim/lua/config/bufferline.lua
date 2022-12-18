local u = require("config.utils")

local api = vim.api

local buftab_template = " %d: %s "
local tab_template = " %d "

local add_hlgroup = function(text, hlgroup)
    return string.format("%%#%s#%s%%*", hlgroup, text)
end

local buffers = {}

local clear_last = function()
    for k in pairs(buffers) do
        buffers[k] = nil
    end
end

local get_current_index = function()
    local current_bufnr = api.nvim_get_current_buf()
    for index, bufnr in pairs(buffers) do
        if bufnr == current_bufnr then
            return index
        end
    end
end

_G.bufferline = function()
    clear_last()

    local current_bufnr = api.nvim_get_current_buf()
    local current_tabnr = api.nvim_get_current_tabpage()
    local budget = tonumber(vim.o.columns)

    local tabs = {}
    for _, tabnr in ipairs(api.nvim_list_tabpages()) do
        local label = tab_template:format(tabnr)
        budget = budget - label:len()

        table.insert(tabs, add_hlgroup(label, tabnr == current_tabnr and "TabLineSel" or "TabLine"))
    end

    local buftabs = {}
    for i, bufnr in
        ipairs(vim.tbl_filter(function(bufnr)
            return vim.bo[bufnr].buflisted and api.nvim_buf_get_name(bufnr) ~= ""
        end, api.nvim_list_bufs()))
    do
        buffers[i] = bufnr
        local name = vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":t")
        if api.nvim_buf_get_option(bufnr, "filetype") == "fugitive" then
            name = "fugitive"
        end

        local label = buftab_template:format(i, name)

        budget = budget - label:len()
        if
            bufnr > current_bufnr -- always fill left tabs
            and budget < 0 -- no more space
        then
            local last_width = budget + label:len()
            if last_width > 0 then -- can truncate
                label = label:sub(1, last_width - 1) .. ">"
            else
                break
            end
        end

        table.insert(buftabs, add_hlgroup(label, bufnr == current_bufnr and "TabLineSel" or "TabLine"))
    end

    local spacer = (" "):rep(budget)
    return table.concat(buftabs) .. spacer .. table.concat(tabs)
end

local make_bufnr_cb = function(cb)
    return function(i)
        local bufnr = buffers[i]
        if not bufnr then
            return
        end

        cb(bufnr)
    end
end

local set_current = make_bufnr_cb(api.nvim_set_current_buf)
local bufdel = make_bufnr_cb(function(bufnr)
    api.nvim_buf_delete(bufnr, {})
end)

for i = 0, 9 do
    u.nmap("<Leader>" .. i, function()
        set_current(i == 0 and 10 or i)
    end)
    u.nmap("<Leader>c" .. i, function()
        bufdel(i == 0 and 10 or i)
    end)
end

local make_current_index_cb = function(cb)
    return function()
        local current = get_current_index()
        if not current then
            return
        end

        cb(current)
    end
end

local delete_current = make_current_index_cb(function(current_index)
    api.nvim_buf_delete(buffers[current_index], {})
end)

local go_to_previous = make_current_index_cb(function(current_index)
    local previous_index = current_index - 1
    if not buffers[previous_index] then
        previous_index = #buffers
    end

    api.nvim_set_current_buf(buffers[previous_index])
end)

local go_to_next = make_current_index_cb(function(current_index)
    local next_index = current_index + 1
    if not buffers[next_index] then
        next_index = #buffers
    end

    api.nvim_set_current_buf(buffers[next_index])
end)

u.nmap("<Leader>cc", delete_current)
u.nmap("<Leader>C", ":%bd|e#<CR>")
u.nmap("<C-n>", go_to_previous)
u.nmap("<C-p>", go_to_next)

vim.opt.tabline = "%!v:lua.bufferline()"
