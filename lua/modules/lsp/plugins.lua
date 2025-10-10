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
  ["Saghen/blink.cmp"] = {
    config = config.cmp,
    event = "InsertEnter",
    version = "v1.*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      'Kaiser-Yang/blink-cmp-avante',
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "hrsh7th/nvim-cmp",
        -- Only install for context utilities, not for completion
        config = false,
      },
    },
  },
  ["nvimtools/none-ls.nvim"] = {
    config = config.none_ls,
    lazy = true,
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
  ["folke/lazydev.nvim"] = {
    ft = "lua",
    config = true,
  },
  ["hedyhli/outline.nvim"] = {
    event = "CmdlineEnter",
    config = config.outline,
  },
}

return completion
