local u = require("config.utils")

if vim.g.started_by_firenvim then
    vim.g.firenvim_config = {
        localSettings = {
            [".*"] = {
                takeover = "never",
            },
        },
    }

    vim.opt.laststatus = 0
    vim.opt.scrolloff = 0
    vim.opt.guifont = "Iosevka:h10"

    u.nmap("<Esc><Esc>", ":call firenvim#focus_page()<CR>")
    u.imap("<D-v>", "<C-r>+")
end
