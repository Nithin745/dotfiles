local u = require("config.utils")

u.nmap("<Leader>gg", ":tab Git<CR>")
u.nmap("<Leader>go", ":GBrowse<CR>")
u.xmap("<Leader>go", ":GBrowse<CR>")
u.nmap("<Leader>gb", ":Git blame<CR>")
u.nmap("<Leader>gw", ":Gwrite<CR>")
u.nmap("<Leader>gd", ":Gdiffsplit!<CR>")
u.nmap("<Leader>gv", ":tab GV!<CR>")
u.nmap("<Leader>gh", ":diffget //2<CR>")
u.nmap("<Leader>gl", ":diffget //3<CR>")
u.nmap("<Leader>gu", ":diffupdate<CR>")
