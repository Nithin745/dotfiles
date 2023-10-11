local u = require("config.utils")


u.nmap("<leader>ja", ":lua require('harpoon.mark').toggle_file()<CR>")
u.nmap("<leader>jj", ":lua require('harpoon.ui').nav_file(1)<CR>")
u.nmap("<leader>jk", ":lua require('harpoon.ui').nav_file(2)<CR>")
u.nmap("<leader>jl", ":lua require('harpoon.ui').nav_file(3)<CR>")
u.nmap("<leader>jh", ":lua require('harpoon.ui').nav_file(4)<CR>")
u.nmap("<leader>jg", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
