local config = require("modules.lsp.config")
local completion = {
  ["ray-x/lsp_signature.nvim"] = {
    dependencies = { "nvim-lspconfig" },
    config = config.lsp_signature,
  },
  ["neovim/nvim-lspconfig"] = {
    event = "VeryLazy",
  },
  ["williamboman/mason.nvim"] = {
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    event = "VeryLazy",
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    config = config.mason_lspconfig,
    dependencies = { "nvim-lspconfig", "mason.nvim" },
  },
  ["L3MON4D3/LuaSnip"] = {
    config = config.luasnip,
    event = "VeryLazy",
    dependencies = {
      "rafamadriz/friendly-snippets",
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
  ["jose-elias-alvarez/null-ls.nvim"] = {
    config = config.null_ls,
    dependencies = { "nvim-lspconfig" },
  },
  ["mfussenegger/nvim-lint"] = {
    config = config.nvim_lint,
    event = "VeryLazy",
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
    ft = "go",
    config = config.go,
    dependencies = {
      "ray-x/guihua.lua",
      build = "cd lua/fzy && make",
      event = "VeryLazy",
    },
  },
}

return completion
