local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      -- lsp config
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  -- Lua Dev
  {
    "folke/neodev.nvim",
    ft = "lua",
    config = function(_, opts)
      -- lua dev setup
      require("neodev").setup {}
    end,
  },

  -- override plugin configs
  -- Override to setup mason-lspconfig
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("orgmode").setup_ts_grammar()
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- List of json schemas
  {
    "b0o/schemastore.nvim",
    ft = "json",
  },

  -- MarkDown Preview
  {
    "davidgranstrom/nvim-markdown-preview",
    cmd = "MarkdownPreview",
    ft = "markdown",
  },

  -- Debug tools
  {
    "mfussenegger/nvim-dap",
    ft = { "python", "lua" },
    init = function()
      require("core.utils").load_mappings "dap"
    end,
    config = function()
      require "custom.configs.dap"
    end,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", "rcarriga/nvim-dap-ui" },
    },
  },

  -- Note Taking
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    keys = { "<leader>oa", "<leader>oc" },
    config = function()
      require "custom.configs.orgmode"
    end,
    dependencies = {
      {
        "akinsho/org-bullets.nvim",
        config = function()
          require("org-bullets").setup()
        end,
      },
    },
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
    -- config = function(_, opts)
    --   require("cmp").setup(opts)
    --   require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    --     sources = {
    --       { name = "dap" },
    --     },
    --   })
    -- end,
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "rcarriga/cmp-dap",
      },
    },
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = { "make" },
      },
    },
    opts = overrides.telescope,
  },

  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function(_, opts)
      require("leap").add_default_mappings()
    end,
  },

  -- Docs generation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    keys = { "<leader>nc", "<leader>nf" },
    init = function(_)
      require("core.utils").load_mappings "neogen"
    end,
    config = function()
      require "custom.configs.neogen"
    end,
    version = "*",
  },

  -- decouple cut and delete operations
  {
    "gbprod/cutlass.nvim",
    event = "VeryLazy",
    opts = {
      cut_key = "m",
      exclude = { "ns", "nS" },
    },
    config = function(_, opts)
      require("cutlass").setup(opts)
    end,
    dependencies = { "svermeulen/vim-subversive" },
  },
  {
    "tpope/vim-surround",
    keys = { "cs", "ds", "ysiw" },
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },
}

return plugins
