local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end
require("config.dap")

require("plugins.mason")
require("plugins.mason-lspconfig")

local u = require("config.utils")

local lsp = vim.lsp
-- lsp.set_log_level("debug")

local border_opts = { border = "single", focusable = false, scope = "line" }

vim.diagnostic.config({ virtual_text = false, float = border_opts, update_in_insert = true })

local eslint_disabled_buffers = {}

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)
lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = true,
})
--     print(config)
--     local client = lsp.get_client_by_id(ctx.client_id)
--     if not (client and client.name == "eslint") then
--         goto done
--     end
--
--     for _, diagnostic in ipairs(result.diagnostics) do
--         if diagnostic.message:find("The file does not match your project config") then
--             local bufnr = vim.uri_to_bufnr(result.uri)
--             eslint_disabled_buffers[bufnr] = true
--         end
--     end
--
--     ::done::
--     return lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
-- end

local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

local lsp_formatting = function(bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      if client.name == "eslint" then
        return not eslint_disabled_buffers[bufnr]
      end

      if client.name == "null-ls" then
        return not u.table.some(clients, function(_, other_client)
          return other_client.name == "eslint" and not eslint_disabled_buffers[bufnr]
        end)
      end
    end,
  })
end

local signature_cfg = {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
}

local on_attach = function(client, bufnr)
  -- commands
  u.buf_command(bufnr, "LspHover", vim.lsp.buf.hover)
  u.buf_command(bufnr, "LspDiagPrev", vim.diagnostic.goto_prev)
  u.buf_command(bufnr, "LspDiagNext", vim.diagnostic.goto_next)
  u.buf_command(bufnr, "LspDiagLine", vim.diagnostic.open_float)
  u.buf_command(bufnr, "LspDiagQuickfix", vim.diagnostic.setqflist)
  u.buf_command(bufnr, "LspSignatureHelp", vim.lsp.buf.signature_help)
  u.buf_command(bufnr, "LspTypeDef", vim.lsp.buf.type_definition)
  -- not sure why this is necessary?
  u.buf_command(bufnr, "LspRename", function()
    vim.lsp.buf.rename()
  end)

  u.buf_command(bufnr, "LspRef", "FzfLua lsp_references")
  u.buf_command(bufnr, "LspSym", "FzfLua lsp_workspace_symbols")
  u.buf_command(bufnr, "LspAct", "FzfLua lsp_code_actions")
  u.buf_command(bufnr, "LspDef", function()
    require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
  end)

  -- bindings
  u.buf_map(bufnr, "n", "gi", ":LspRename<CR>")
  u.buf_map(bufnr, "n", "K", ":LspHover<CR>")
  u.buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
  u.buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
  u.buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
  u.buf_map(bufnr, "i", "<C-x><C-x>", "<cmd>LspSignatureHelp<CR>")

  u.buf_map(bufnr, "n", "gy", ":LspRef<CR>")
  u.buf_map(bufnr, "n", "gh", ":LspTypeDef<CR>")
  u.buf_map(bufnr, "n", "gd", ":LspDef<CR>")
  u.buf_map(bufnr, "n", "ga", ":LspAct<CR>")
  u.buf_map(bufnr, "x", "ga", function()
    vim.lsp.buf.code_action() -- range
  end)

  if client.server_capabilities.definitionProvider then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
  end
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.formatexpr()")
  end
  -- if client.name ~= "rust_analyzer" or client.name ~= "null-ls" then
  --   vim.schedule(function () print(client.name .. " hello") end)
  --   require("lsp_signature").on_attach(signature_cfg, bufnr)
  -- end
  if client.supports_method("textDocument/formatting") then
    local formatting_cb = function()
      lsp_formatting(bufnr)
    end
    u.buf_command(bufnr, "LspFormatting", formatting_cb)
    u.buf_map(bufnr, "x", "<CR>", formatting_cb)
    u.nmap("<Leader>lf", ":lua vim.lsp.buf.format({async=true})<CR>")
    -- u.xmap("<Leader>lf", ":lua vim.lsp.buf.format({async=true})<CR>")
    u.vmap("<Leader>lf", function()
      local start_line, _, _, _ = unpack(vim.fn.getpos("'<"))
      local end_line, _, _, _ = unpack(vim.fn.getpos("'>"))

      local range = {
        start = { line = start_line, character = 0 },
        ["end"] = { line = end_line, character = 0 },
      }

      vim.lsp.buf.format({ range = range })
    end)

    --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --         group = augroup,
    --         buffer = bufnr,
    --         command = "LspFormatting",
    --     })
  end

  require("illuminate").on_attach(client)
end

local after_init = function(client, bufnr)
  -- require("lsp_signature").on_attach(signature_cfg, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- require "lsp_signature".setup(signature_setup)
local servers = {
  "lua_ls",
  "pyright",
  "jsonls",
  "tsserver",
  "null-ls",
  "yamlls",
  "html",
  -- "rust_analyzer",
  "marksman",
  "emmet_ls",
  "css_ls",
  "bashls",
  "dockerls",
  -- "sqlls",
  -- "ltex"
  "rust_tools",
}

for _, server in ipairs(servers) do
  require("lsp." .. server).setup(on_attach, capabilities, after_init)
end

-- suppress irrelevant messages
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("%[lspconfig%]") then
    return
  end

  if msg:match("warning: multiple different client offset_encodings") then
    return
  end

  notify(msg, ...)
end
