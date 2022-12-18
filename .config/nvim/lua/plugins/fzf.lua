local u = require("config.utils")

require("fzf-lua").setup({
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        },
    },
    previewers = {
        bat = {
            cmd = "bat",
            args = "--style=numbers,changes --color always",
            theme = "gruvbox-dark",
        }
    },
    -- buffers = {
    --     previewer = 'bat'
    -- },
    winopts = {
        height = 0.95,
        width = 0.95,
        preview = {
            scrollbar = false,
            default = 'bat_native',
        },
    },
    fzf_opts = {
        ["--layout"] = "default",
        -- ["--ansi"] = false, --makes fzf fast, but have some limitations
    },
    files = {
        -- cmd = 'find * -name ".git" -o -name "node_modules" -o -name "__pycache__" -prune -o -type f -print',
        -- find_opts         = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g '!.git'",
        fd_opts = "-t f -E node_modules -E venv -E __pycache__  -E venv",
        actions = {
            ["ctrl-e"] = function(selected)
                for i, item in ipairs(selected) do
                    local command = i == 1 and "edit" or i % 2 == 0 and "vsplit" or "split"
                    vim.cmd(string.format("%s %s", command, item))
                end
            end,
        },
    },
})

-- fzf.vim-like commands
-- u.command("ManPages", "FzfLua man_pages")

u.nmap("<Leader>fc", function()
    local search = vim.fn.getreg("*"):gsub("\n", "")
    require("fzf-lua").grep({ search = search })
end)
u.nmap("<Leader>ff", "<cmd>FzfLua files<CR>")
u.nmap("<Leader>cs", "<cmd>FzfLua colorschemes<CR>")
u.nmap("<Leader>fg", "<cmd>FzfLua git_files<CR>")
u.nmap("<Leader>fs", "<cmd>FzfLua live_grep_glob<CR>")
u.nmap("<Leader>fh", "<cmd>FzfLua help_tags<CR>")
u.nmap("<Leader>fo", "<cmd>FzfLua oldfiles<CR>")
u.nmap("<Leader>fw", "<cmd>FzfLua grep_cWORD<CR>")
u.nmap("<Leader><Leader>", "<cmd>FzfLua buffers<CR>")
u.nmap("<LocalLeader><LocalLeader>", "<cmd>FzfLua grep_curbuf<CR>")
u.nmap("<Leader>cd", function()
    _G.fzf_dirs({ cwd = '~' })
end)
u.nmap("<Leader>fx", function()
    _G.fzf_files({ cwd = '~/Public/orgmode/' })
end)
