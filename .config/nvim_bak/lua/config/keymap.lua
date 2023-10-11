local u = require("config.utils")

-- default to black hole register
u.nmap("d", '"_d')
u.xmap("d", '"_d')
u.nmap("dd", '"_dd')
u.nmap("D", '"_D')

u.nmap("c", '"_c')
u.xmap("c", '"_c')
u.nmap("cc", '"_cc')
u.nmap("C", '"_C')

u.nmap("x", '"_x')
u.xmap("x", '"_x')
u.nmap("X", '"_X')

u.nmap("m", "d")
u.xmap("m", "d")
u.nmap("mm", "dd")
u.nmap("M", "D")

-- Markdown 
u.nmap("<Leader>mp", ":MarkdownPreview<CR>")
-- make going to normal mode from terminals less painful
u.tmap("<C-o>", "<C-\\><C-n>")

-- make useless keys useful
u.nmap("<BS>", "<C-^>")

u.imap("<S-Tab>", "<C-o>A")

u.nmap("<Esc>", ":nohl<CR>")

u.nmap("H", "^")
u.omap("H", "^")
u.xmap("H", "^")
u.nmap("L", "$")
u.omap("L", "$")
u.xmap("L", "$")


-- misc
u.xmap(">", ">gv")
u.xmap("<", "<gv")

u.nmap("n", "nzz")
u.nmap("N", "Nzz")
u.nmap("vv", "V")

-- navigate jump list
-- u.nmap("[[", "<C-o>")
-- u.nmap("]]", "<Tab>")

-- Comment with Ctrl-/
u.nmap("<C-_>", "gcc", { remap = true })
u.xmap("<C-_>", "gc", { remap = true })
u.nmap("<C-/>", "gcc", { remap = true })
u.xmap("<C-/>", "gc", { remap = true })

-- Ctrl-Up/Down scrolls 10 lines and keep the screen centered
u.nmap("<C-Up>", "10kzz")
u.nmap("<C-Down>", "10jzz")

-- tab navigation
u.nmap("<C-p>", "gT")
u.nmap("<C-n>", "gt")

-- <c-w>T open in new tab

-- backslash for macros, q for quit
u.nmap("\\", "q")
u.nmap("|", "Q")
u.nmap("q", ":quit<CR>")
u.nmap("Q", ":quit!<CR>")


-- u.nmap("<C-n>", ":bnext<CR>")
-- u.nmap("<C-p>", ":bprevious<CR>")

u.nmap("<Leader>tp", "<cmd>TSPlaygroundToggle<CR>")

-- Resize windows
u.nmap("(", "<c-w>5<")
u.nmap(")", "<c-w>5>")

-- Toggle DBUI
u.nmap("<Leader>du", "<cmd>DBUIToggle<CR>")
u.nmap("<Leader>ds", "<plug>(DBUI_SaveQuery)", {noremap=true})

-- fzf
-- u.map("<Leader>nx", ":lua require('fzf-lua').fzf_live('rg -n',{previewer='bat_native'})<CR>")
