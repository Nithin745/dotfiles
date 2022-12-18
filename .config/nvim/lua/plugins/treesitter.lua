require('orgmode').setup_ts_grammar()
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "fish",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "make",
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
        "org"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'org' },
        disable = function(_, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
    },
    -- plugins
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    textsubjects = {
        enable = true,
        keymaps = { ["."] = "textsubjects-smart" },
    },
    autotag = { enable = true },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            -- You can choose the select mode (default is charwise 'v')
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding xor succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            include_surrounding_whitespace = true,
        },
    },
    indent = { enable = true, disable = {"python", "org"} },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<M-s>",
            node_incremental = "<M-s>",
        },
    },
    playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
})
