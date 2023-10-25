local M = {}
local cmp = require "cmp"
local _, neogen = pcall(require, "neogen")
local action = require "telescope.actions"

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "markdown",
    "markdown_inline",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "yaml",
    "python",
    "html",
    "sql",
    "http",
    "dockerfile",
    "rust",
    "org",
    "rego",
  },
  indent = {
    enable = true,
    disable = {
      "python",
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.cmp = {
  mapping = {
    ["<C-y>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<CR>"] = cmp.config.disable,
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      elseif neogen.jumpable() then
        neogen.jump_next()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      elseif neogen.jumpable(true) then
        neogen.jump_prev()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  sources = {
    { name = "nvim_lua", max_item_count = 4 },
    { name = "nvim_lsp", priority = 998, max_item_count = 5 },
    { name = "luasnip", priority = 999, keyword_length = 2, max_item_count = 1 },
    {
      name = "buffer",
      option = {
        -- complete from visible buffers
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
      max_item_count = 4,
    },
    { name = "path" },
    { name = "dap", filetype = { "dap-repl", "dapui_watches" } },
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
}

M.telescope = {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", "venv", "__pycache__" },
  },
  -- mappings = {
  --   ["<C-t>"] = action.select_tab,
  -- },
  extensions_list = { "themes", "terms", "fzf" },
}

M.gitsigns = {
  update_debounce = 500
}
return M
