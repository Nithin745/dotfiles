local u = require("config.utils")

-- make global to make ex commands easier
_G.inspect = function(...)
    print(vim.inspect(...))
end

-- change dir with fzf
_G.fzf_dirs = function(opts)
  local fzf_lua = require'fzf-lua'
  opts = opts or {}
  opts.prompt = "Directories> "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ['default'] = function(selected)
      vim.cmd("cd " .. "/home/nithin/" .. selected[1])
    end
  }
  fzf_lua.fzf_exec("fd --type d -E node_modules -E __pycache__ -E venv", opts)
end

_G.fzf_files = function (opts)
  local fzf_lua = require('fzf-lua')
  opts = opts or {}
  opts.prompt = "Files> "
  opts.show_cwd_header = false
  fzf_lua.files(opts)
end

_G.org_todo_fzf = function (opts)
  local org = require("orgmode.api")
  local fzf_lua = require('fzf-lua')
  local files = org.load()
  opts = opts or {}
  local headlines = {}
  for _, file in ipairs(files) do
    vim.list_extend(headlines, vim.tbl_map(function (h)
      return h.line
    end, file.headlines))
  end
  fzf_lua.fzf_exec(headlines, opts)
end

-- reset treesitter and lsp diagnostics
u.command("R", "w | :e")

