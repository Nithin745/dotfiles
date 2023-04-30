local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}


return require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim" })

    local config = function(name)
        return string.format("require('plugins.%s')", name)
    end

    local use_with_config = function(path, name)
        use({ path, config = config(name) })
    end

    -- basic
    use("tpope/vim-surround")
    use("tpope/vim-unimpaired")
    use("tpope/vim-repeat")
    use("tpope/vim-sleuth")
    use("tpope/vim-eunuch")
    use_with_config("numToStr/Comment.nvim", "comment")
    use_with_config("lewis6991/gitsigns.nvim", "gitsigns")
    use({
        "tpope/vim-fugitive",
        requires = { "tpope/vim-rhubarb", "junegunn/gv.vim" },
        config = config("fugitive"),
    })

    -- text objects
    use("wellle/targets.vim") -- many useful additional text objects
    use({
        "kana/vim-textobj-user",
        {
            "kana/vim-textobj-entire", -- ae/ie for entire buffer
            "Julian/vim-textobj-variable-segment", -- av/iv for variable segment
            "michaeljsmith/vim-indent-object", -- ai/ii for indentation area
            "beloglazov/vim-textobj-punctuation", -- au/iu for punctuation
        },
    })

    -- registers
    use_with_config("svermeulen/vim-subversive", "subversive") -- adds substitute operator
    -- use_with_config("svermeulen/vim-cutlass", "cutlass") -- separates cut and delete operations
    use("tversteeg/registers.nvim") -- show list of items in clipboard registers

    -- additional functionality
    use("ggandor/lightspeed.nvim") -- motion
    use_with_config("dcampos/nvim-snippy", "snippy") -- snippets
    use("honza/vim-snippets")
    use({
        "hrsh7th/nvim-cmp", -- completion
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "dcampos/cmp-snippy",
            "andersevenrud/cmp-tmux",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "rcarriga/cmp-dap",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-nvim-lsp-signature-help"
        },
        config = config("cmp"),
    })
    -- use({ "junegunn/fzf", run = "./install --bin" })
    use_with_config("windwp/nvim-autopairs", "autopairs") -- autocomplete pairs
    use_with_config("ibhagwan/fzf-lua", "fzf") -- better lua version of fzf.vim
    use_with_config("luukvbaal/nnn.nvim", "nnn") --- nnn integration
    use_with_config("simnalamburt/vim-mundo", "mundo") -- undo tree visualization
    use_with_config("danymat/neogen", "neogen")

    -- lsp
    use("neovim/nvim-lspconfig") -- makes lsp configuration easier
    use("folke/neodev.nvim") -- better sumneko_lua settings
    use("b0o/schemastore.nvim") -- simple access to json-language-server schemae
    -- use { "ray-x/lsp_signature.nvim" } -- show function signature when you type
    use_with_config("RRethy/vim-illuminate", "illuminate") -- highlights and allows moving between variable references
    use("williamboman/mason.nvim") -- install external tool
    use("williamboman/mason-lspconfig.nvim") -- install lsp servers

    -- Formatting and linting
    use("jose-elias-alvarez/null-ls.nvim")

    -- Performance
    use("lewis6991/impatient.nvim")

    -- treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = config("treesitter"),
        requires = {
            { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
            { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle" } },
            { "RRethy/nvim-treesitter-textsubjects", event = "BufReadPre" }, -- adds smart text objects
            { "nvim-treesitter/nvim-treesitter-context", config = config("treesitter-context")}, -- sticky func, class, if...
            { "windwp/nvim-ts-autotag" }, -- automatically close jsx tags
            { "JoosepAlviste/nvim-ts-context-commentstring" }, -- makes jsx comments actually work
        }
    })
    use("jose-elias-alvarez/nvim-lsp-ts-utils")
    use("jose-elias-alvarez/typescript.nvim")
    use_with_config("mizlan/iswap.nvim", "iswap") -- interactively swap function arguments
    use("simrat39/rust-tools.nvim") -- rust Lsp utils

    -- visual
    use({
        "sainnhe/sonokai",
        "sainnhe/edge",
        -- "rmehri01/onenord.nvim",
        "folke/tokyonight.nvim",
        "tanvirtin/monokai.nvim",
        "sainnhe/gruvbox-material",
        "EdenEast/nightfox.nvim",
        "navarasu/onedark.nvim",
    })
    --[[ use { "Everblush/everblush.nvim", as = "everblush" } ]]
    use("kyazdani42/nvim-web-devicons") -- dev icons
    use_with_config("norcalli/nvim-colorizer.lua", "colorizer") -- highlight color codes
    use_with_config("feline-nvim/feline.nvim", "feline") -- status

    -- Tabline
    use { 'alvarosevilla95/luatab.nvim', requires='kyazdani42/nvim-web-devicons' }


    -- misc
    use("nvim-lua/plenary.nvim")
    use { "nvim-lua/popup.nvim" }
    use({
        "glacambre/firenvim",
        config = config("firenvim"),
        run = function()
            vim.fn["firenvim#install"](0)
        end,
    })
    use({
        "davidgranstrom/nvim-markdown-preview", -- preview markdown output in browser
        opt = true,
        ft = { "markdown" },
        cmd = "MarkdownPreview",
    })

    -- key-map
    use_with_config("linty-org/key-menu.nvim", "key_map")

    -- file navigation
    use_with_config("ThePrimeagen/harpoon", "harpoon")

    -- dap
    use({ "mfussenegger/nvim-dap" })
    use({ "theHamsta/nvim-dap-virtual-text" })
    use({ "rcarriga/nvim-dap-ui" })
    use({ "mfussenegger/nvim-dap-python" })

    -- note-taking
    use({"nvim-orgmode/orgmode",
        config = config("orgmode"),
        requires = {
            {"nvim-treesitter/nvim-treesitter"}
        },
    })
    --[[ use_with_config("lukas-reineke/headlines.nvim", "headlines") ]]
    use_with_config("akinsho/org-bullets.nvim", "org_bullets")
    use("dhruvasagar/vim-table-mode")

    -- sxhkd syntax highlighting
    use("baskerville/vim-sxhkdrc")

    -- database
    use("tpope/vim-dadbod")
    use("kristijanhusak/vim-dadbod-ui")
    use("kristijanhusak/vim-dadbod-completion")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
