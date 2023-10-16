local config = require("modules.lsp.config")
local completion = {
  ["ray-x/lsp_signature.nvim"] = {
    lazy = true,
  },
  ["neovim/nvim-lspconfig"] = {
    event = "VeryLazy",
  },
  ["williamboman/mason.nvim"] = {
    -- :MasonUpdate updates registry contents
    build = ":lua require('mason.api.command').MasonUpdate()",
    event = "VeryLazy",
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    config = config.mason_lspconfig,
    dependencies = { "nvim-lspconfig", "mason.nvim" },
  },
  ["L3MON4D3/LuaSnip"] = {
    config = config.luasnip,
    event = "InsertEnter",
    dependencies = {
      "honza/vim-snippets",
    },
  },
  ["hrsh7th/nvim-cmp"] = {
    config = config.cmp,
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind-nvim",
      "lukas-reineke/cmp-under-comparator",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lua",
      "f3fora/cmp-spell",
      "saadparwaiz1/cmp_luasnip",
      {
        "uga-rosa/cmp-dictionary",
        config = config.dictionary,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = "tpope/vim-dadbod",
      },
      {
        "jcdickinson/codeium.nvim",
        config = true,
      },
    },
  },
  ["nvimtools/none-ls.nvim"] = {
    config = config.none_ls,
    lazy = true,
  },
  ["ii14/lsp-command"] = {
    dependencies = "nvim-lspconfig",
  },
  ["rmagatti/goto-preview"] = {
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
    config = config.goto_preview,
  },
  ["someone-stole-my-name/yaml-companion.nvim"] = {
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
  },
  ["ray-x/go.nvim"] = {
    ft = { "go", "gomod" },
    event = { "CmdlineEnter" },
    config = config.go,
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  ["Fildo7525/pretty_hover"] = {
    event = "LspAttach",
    opts = {},
  },
  ["folke/neodev.nvim"] = {
    lazy = true,
  },
  ["simrat39/symbols-outline.nvim"] = {
    event = "CmdlineEnter",
    config = config.symbols_outline,
  },
}

return completion
