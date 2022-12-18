local u = require("config.utils")

-- gr to substitute (replace with register contents)
u.nmap("gr", "<Plug>(SubversiveSubstitute)")
u.xmap("gr", "<Plug>(SubversiveSubstitute)")
u.nmap("grr", "<Plug>(SubversiveSubstituteLine)")
u.nmap("gR", "<Plug>(SubversiveSubstituteToEndOfLine)")

-- = to substitute word in 1st motion over 2nd motion
u.nmap("=", "<Plug>(SubversiveSubstituteRange)")
u.xmap("=", "<Plug>(SubversiveSubstituteRange)")
-- substitute current word over motion
u.nmap("==", "<Plug>(SubversiveSubstituteWordRange)")
