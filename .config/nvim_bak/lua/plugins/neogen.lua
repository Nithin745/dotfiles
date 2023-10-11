local u = require("config.utils")

require("neogen").setup({ snippet_engine = "snippy" })

u.nmap("<Leader>n", ":Neogen<CR>")
