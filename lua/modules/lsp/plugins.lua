-- TODO: configure kristijanhusak/vim-dadbod-completion
local config = require("modules.lsp.config")
local completion = {
  ["ray-x/lsp_signature.nvim"] = {},
  -- FIXME: display errorneous function comment
  ["neovim/nvim-lspconfig"] = {
    config = config.lsp_signature,
    after = "lsp_signature.nvim",
  },
  ["williamboman/nvim-lsp-installer"] = {
    config = config.lsp_installer,
    after = { "nvim-lspconfig", "cmp-nvim-lsp" },
  },
  ["lukas-reineke/cmp-under-comparator"] = {},
  ["onsails/lspkind-nvim"] = {},
  ["hrsh7th/nvim-cmp"] = {
    config = config.cmp,
    after = { "lspkind-nvim", "cmp-under-comparator" },
  },
  ["hrsh7th/cmp-buffer"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-cmdline"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-path"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lsp"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-calc"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lua"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["kristijanhusak/vim-dadbod-completion"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  ["f3fora/cmp-spell"] = {
    requires = "nvim-cmp",
    after = "nvim-cmp",
  },
  -- FIXME: com-dictionary slow down completion
  -- Perhaps I can only enable it in comment or when spell is enabled.
  -- See nvim-cmp PR [add function to check if in comment #676]
  --
  -- ["uga-rosa/cmp-dictionary"] = {
  -- requires = "nvim-cmp",
  -- after = "nvim-cmp",
  -- config = config.dictionary,
  -- },
  ["petertriho/cmp-git"] = {
    requires = "nvim-lua/plenary.nvim",
    after = "nvim-cmp",
    config = config.cmp_git(),
  },
  ["L3MON4D3/LuaSnip"] = {
    config = config.luasnip,
    requires = "nvim-cmp",
  },
  ["saadparwaiz1/cmp_luasnip"] = {
    requires = { "nvim-cmp", "rafamadriz/friendly-snippets" },
    after = { "LuaSnip", "nvim-cmp" },
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    config = config.null_ls,
  },
  ["ii14/lsp-command"] = {
    after = { "nvim-lspconfig" },
  },
  ["filipdutescu/renamer.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = config.renamer,
  },
}

return completion
