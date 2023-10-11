local cmp = require("cmp")
local compare = require("cmp.config.compare")

local snippy = require("snippy")
local handlers = require("nvim-autopairs.completion.handlers")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  -- completion = {
  --     completeopt = "menuone,noinsert,noselect",
  -- },
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
    ["<C-e>"] = cmp.mapping(function()
      cmp.abort()
    end, { "i", "s" }),
    ["<C-y>"] = cmp.mapping({
      i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
    }),
  },
  -- sorting = {
  --     comparators = {
  --         compare.locality,
  --         compare.recently_used,
  --         compare.sort_text,
  --         compare.score
  --     }
  -- },
  sources = {
    -- only show one snippet, and always show at top
    { name = "orgmode", priority = 9997 },
    { name = "nvim_lua" },
    { name = "snippy", priority = 9999, keyword_length = 2, max_item_count = 1 },
    { name = "nvim_lsp_signature_help" },
    {
      name = "nvim_lsp",
      priority = 9998,
      -- entry_filter = function (entry, ctx)
      --     local kind = entry:get_kind()
      --     local line = ctx.cursor_line
      --     local col = ctx.cursor.col
      --     local char_before_cursor = string.sub(line, col-1, col-1)
      --     if char_before_cursor == "." then
      --         if kind == 2 and kind == 5 then
      --             return true
      --         else
      --             return false
      --         end
      --     elseif string.match(line, "^%s*%W*$") then
      --         if kind == 3 and kind == 6 then
      --             return true
      --         else
      --             return false
      --         end
      --     end
      --     return true
      -- end
    },
    { name = "path" },
    { name = "tmux" },
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
    },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        orgmode = "[org]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        snippy = "[Snip]",
        buffer = "[Buffer]",
        treesitter = "[TS]",
        path = "[Path]",
        nvim_lsp_signature_help = "[Signature]",
        ["vim-dadbod-completion"] = "[DB]",
      })[entry.source.name]
      local item = entry:get_completion_item()
      if item.detail then
        vim_item.menu = item.detail
      end
      return vim_item
    end,
  },
  -- format_signature = function(sig_help)
  --   return {
  --     border = "rounded",
  --     max_width = 80,
  --     max_height = 20,
  --     offset_x = 0,
  --     offset_y = 1,
  --     padding = " ",
  --     -- Use the text returned by the LSP as the content of the signature help
  --     data = sig_help,
  --   }
  -- end,
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
})

cmp.setup.cmdline({ ":", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "cmdline" },
  },
})

require("cmp").setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" },
  }),
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches" }, {
  sources = {
    { name = "dap" },
  },
})

require("cmp").setup.filetype({ "sql", "mysql", "psql" }, {
  sources = {
    { name = "vim-dadbod-completion" },
  },
})

cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done({
    filetypes = {
      -- "*" is a alias to all filetypes
      ["*"] = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = handlers["*"],
        },
      },
      --[[ lua = { ]]
      --[[   ["("] = { ]]
      --[[     kind = { ]]
      --[[       cmp.lsp.CompletionItemKind.Function, ]]
      --[[       cmp.lsp.CompletionItemKind.Method ]]
      --[[     }, ]]
      --[[     --@param char string ]]
      --[[     --@param item item completion ]]
      --[[     --@param bufnr buffer number ]]
      --[[     handler = function(char, item, bufnr) ]]
      --[[                   print(vim.inspect{char, item, bufnr}) ]]
      --[[       -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr}) ]]
      --[[     end ]]
      --[[   } ]]
      --[[ }, ]]
      -- Disable for tex
      tex = false,
    },
  })
)

--[[ cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()) ]]
