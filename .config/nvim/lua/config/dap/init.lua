local u = require("config.utils")
require("dapui").setup()
local virtual_text = {
  only_first_definition = true
}
require('nvim-dap-virtual-text').setup(virtual_text)
require("config.dap.python")

local dap = require('dap')
--[[ dap.set_log_level('TRACE') ]]

local dap_breakpoint = {
  error = {
    text = "🟥",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
  },
  rejected = {
    text = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = "⭐️",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  },
}
vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)


u.nmap('<F9>', ':lua require("dap").run_to_cursor()<CR>')
u.nmap('<F8>', ':lua require("dap").step_over()<CR>')
u.nmap('<F7>', ':lua require("dap").step_out()<CR>')
u.nmap('<F6>', ':lua require("dap").step_into()<CR>')
u.nmap('<F5>', ':lua require("dap").continue()<CR>')
u.nmap('<Leader>dr', ':lua require("dap").run_last()<CR>')
u.nmap('<Leader>dv', ':lua require("dap.ui.widgets").hover()<CR>')
u.nmap('<Leader>db', ':lua require("dap").toggle_breakpoint()<CR>')
u.nmap('<Leader>dH', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
u.nmap('<Leader>dc', ':lua require("dap").terminate()<CR>')
u.nmap('<Leader>di', ':lua require("dapui").toggle()<CR>')
u.nmap('<Leader>do', ':lua require("dapui").open()<CR>')


