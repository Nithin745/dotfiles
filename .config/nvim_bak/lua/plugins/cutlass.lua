local u = require("config.utils")

-- m to "cut" (original delete operation)
u.nmap("m", "d")
u.xmap("m", "d")
u.nmap("mm", "dd")
u.nmap("M", "D")

-- gm for marks
u.nmap("gm", "m")
