local u = require("config.utils")
local dapui = require("dapui")
require("dapui").setup({
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.25,
        },
        {
          id = "breakpoints",
          size = 0.25,
        },
        {
          id = "stacks",
          size = 0.25,
        },
        {
          id = "watches",
          size = 0.25,
        },
      },
      position = "left",
      size = 40,
    },
    {
      elements = { {
        id = "console",
        size = 1,
      } },
      position = "bottom",
      size = 10,
    },
  },
})
local virtual_text = {
  only_first_definition = true,
}
require("nvim-dap-virtual-text").setup(virtual_text)
require("config.dap.python")

-- local dap = require('dap')
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

u.nmap("<F9>", ':lua require("dap").run_to_cursor()<CR>')
u.nmap("<F8>", ':lua require("dap").step_over()<CR>')
u.nmap("<F7>", ':lua require("dap").step_out()<CR>')
u.nmap("<F6>", ':lua require("dap").step_into()<CR>')
u.nmap("<F5>", ':lua require("dap").continue()<CR>')
u.nmap("<C-F8>", ':lua require("dap").step_back()<CR>')
u.nmap("<C-F5>", ':lua require("dap").reverse_continue()<CR>')
u.nmap("<Leader>dr", ':lua require("dap").run_last()<CR>')
u.nmap("<Leader>dv", ':lua require("dap.ui.widgets").hover()<CR>')
u.nmap("<Leader>db", ':lua require("dap").toggle_breakpoint()<CR>')
u.nmap("<Leader>dH", ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
u.nmap("<Leader>dc", ':lua require("dap").terminate()<CR>')
u.nmap("<Leader>di", ':lua require("dapui").toggle()<CR>')
u.nmap("<Leader>do", function()
  local buffer = dapui.elements["repl"].buffer()
  vim.cmd("tabnew")
  vim.api.nvim_win_set_buf(0, buffer)
  u.get_buf_name("repl")
end)
-- u.nmap('<Leader>dq', ':lua require("dapui").close(3)<CR>')
