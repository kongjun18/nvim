-- TODO: configure kristijanhusak/vim-dadbod-completion
local config = require("modules.lsp.config")
local completion = {
  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = config.lsp_signature,
  },
  -- FIXME: display errorneous function comment
  ["neovim/nvim-lspconfig"] = {
    event = { "BufReadPre", "BufNewFile" },
  },
  ["williamboman/nvim-lsp-installer"] = {
    config = config.lsp_installer,
    after = "nvim-lspconfig",
  },
  ["L3MON4D3/LuaSnip"] = {
    config = config.luasnip,
    requires = "hrsh7th/nvim-cmp",
    opt = true, -- Load in after nvim-cmp
  },
  ["hrsh7th/nvim-cmp"] = {
    config = config.cmp,
    event = { "InsertEnter", "CmdlineEnter" }, -- Will make first insert slow
    requires = {
      "onsails/lspkind-nvim",
      "lukas-reineke/cmp-under-comparator",
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
      { "hrsh7th/cmp-calc", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
      { "f3fora/cmp-spell", after = "nvim-cmp" },
      {
        "kristijanhusak/vim-dadbod-completion",
        requires = "tpope/vim-dadbod",
        after = "nvim-cmp",
      },
      {
        "petertriho/cmp-git",
        requires = "nvim-lua/plenary.nvim",
        after = "nvim-cmp",
        config = config.cmp_git(),
      },
      {
        "saadparwaiz1/cmp_luasnip",
        requires = "LuaSnip",
        after = "nvim-cmp",
      },
    },
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    config = config.null_ls,
    event = { "InsertLeave", "BufWritePre" },
    keys = "gf",
  },
  ["ii14/lsp-command"] = {
    requires = "nvim-lspconfig",
    after = "nvim-lspconfig",
    cmd = "Lsp",
  },
}

return completion
