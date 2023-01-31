local u = require("config.utils")

local illuminate = require("illuminate")

illuminate.configure({
    large_file_cutoff = 2500
})

u.nmap("<M-n>", function()
    illuminate.next_reference({ wrap = true })
end)
u.nmap("<M-p>", function()
    illuminate.next_reference({ reverse = true, wrap = true })
end)
