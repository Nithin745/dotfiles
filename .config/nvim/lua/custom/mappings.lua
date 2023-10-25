---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<BS>"] = { "<C-^>", "Switch to alternate file", opts = { nowait = true } },
    ["<leader>U"] = { "<cmd>UndotreeToggle<CR>", "Undo tree" },
    ["<C-n>"] = { "gt", "next tab" },
    ["<C-p>"] = { "gT", "prev tab" },
    -- gr to substitute (replace with register contents)
    ["gr"] = { "<Plug>(SubversiveSubstitute)", "Substitute word" },
    ["grr"] = { "<Plug>(SubversiveSubstituteLine)", "Substitute line" },
    ["gR"] = { "<Plug>(SubversiveSubstituteToEndOfLine)", "Substitute to end of line" },
    ["yw"] = { "yiw", "copy word without space" },
  },
  x = {
    [">"] = { ">gv", "move line right" },
    ["<"] = { "<gv", "move line right" },
    -- gr to substitute (replace with register contents)
    ["gr"] = { "<Plug>(SubversiveSubstitute)", "Substitute word" },
    ["grr"] = { "<Plug>(SubversiveSubstituteLine)", "Substitute line" },
    ["gR"] = { "<Plug>(SubversiveSubstituteToEndOfLine)", "Substitute to end of line" },
  },
  -- i = {
  --   ["S-tab"] = { "<C-o>A", "move to end of line" }
  -- }
}
M.comment = {
  -- toggle comment in both modes
  n = {
    -- ["<C-/>"] = {
    --   function()
    --     require("Comment.api").toggle.linewise.current()
    --   end,
    --   "toggle comment",
    --   opts = { remap = true },
    -- },
    ["<C-_>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
      opts = { remap = true },
    },
  },

  v = {
    -- ["<C-/>"] = {
    --   "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    --   "toggle comment",
    --   opts = { remap = true },
    -- },
    ["<C-_>"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
      opts = { remap = true },
    },
  },
}

M.dap = {
  -- if you set this flag you have to maunually load keybindings
  plugin = true,
  -- dap ui keybindings
  n = {
    ["<F5>"] = { "<cmd> lua require('dap').continue() <CR>", "Dap continue" },
    ["<F6>"] = { "<cmd> lua require('dap').step_into() <CR>", "Dap step into" },
    ["<F7>"] = { "<cmd> lua require('dap').step_out() <CR>", "Dap step out" },
    ["<F8>"] = { "<cmd> lua require('dap').step_over() <CR>", "Dap step over" },
    ["<F9>"] = { "<cmd> lua require('dap').run_to_cursor() <CR>", "Dap run to cursor" },
    ["<leader>dc"] = { "<cmd>lua require('dap').terminate() <CR>", "Dap terminate" },
    ["<leader>dr"] = { "<cmd>lua require('dap').run_last() <CR>", "Dap run last" },
    ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint() <CR>", "Dap toggle breakpoint" },
    ["<leader>dv"] = { "<cmd>lua require('dap.ui.widgets').hover() <CR>", "Dap eval" },
    ["<leader>dH"] = {
      "<cmd> lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: ')) <CR>",
      "Dap conditional breakpoint",
    },
    ["<leader>di"] = { "<cmd> lua require('dapui').toggle() <CR>", "Dap open ui" },
  },
}

M.nvimtree = {
  n = {
    -- toggle
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Focus nvimtree" },
  },
}

M.neogen = {
  plugin = true,

  n = {
    ["<leader>gc"] = { "<cmd> lua require('neogen').generate({ type = 'class' }) <CR>", "Generate class doc" },
    ["<leader>gf"] = { "<cmd> lua require('neogen').generate({ type = 'func' }) <CR>", "Generate function doc" },
  },
}

M.lspconfig = {
  n = {
    ["gy"] = {
      function()
        vim.lsp.buf.references()
      end,
      "lsp references",
    },
  },
}

M.harpoon = {
  n = {
    ["<leader>ja"] = { "<cmd> lua require('harpoon.mark').toggle_file() <CR>", "Harpoon add toggle" },
    ["<leader>jj"] = { "<cmd> lua require('harpoon.ui').nav_file(1) <CR>", "Harpoon file 1" },
    ["<leader>jk"] = { "<cmd> lua require('harpoon.ui').nav_file(2) <CR>", "Harpoon file 2" },
    ["<leader>jl"] = { "<cmd> lua require('harpoon.ui').nav_file(3) <CR>", "Harpoon file 3" },
    ["<leader>jh"] = { "<cmd> lua require('harpoon.ui').nav_file(4) <CR>", "Harpoon file 4" },
    ["<leader>jg"] = { "<cmd> lua require('harpoon.ui').toggle_quick_menu() <CR>", "Harpoon list" },
  },
}

M.disabled = {
  n = {
    ["<leader>/"] = "",
    -- ["<C-n>"] = "",
    -- ["<C-p>"] = "",
    ["<tab>"] = "",
    ["<S-tab>"] = "",
  },

  v = {
    ["<leader>/"] = "",
  },
}

return M
