local config = require("modules.ui.config")
local ui = {
  ["kyazdani42/nvim-tree.lua"] = {
    config = config.nvim_tree,
    event = "CmdlineEnter",
  },
  ["EdenEast/nightfox.nvim"] = {
    config = config.nightfox,
  },
  ["arkav/lualine-lsp-progress"] = {
    after = "nvim-gps",
  },
  ["SmiteshP/nvim-gps"] = {
    config = config.gps,
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
  },
  ["nvim-lualine/lualine.nvim"] = {
    config = config.lualine,
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    after = { "nvim-gps" },
  },
  ["alvarosevilla95/luatab.nvim"] = {
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = config.luatab,
    event = "BufReadPost",
  },
  ["jeffkreeftmeijer/vim-numbertoggle"] = {
    event = "BufReadPost",
  },
  ["camspiers/animate.vim"] = {
    opt = true,
  },
  ["camspiers/lens.vim"] = {
    config = config.lens,
    requires = "animate.vim",
    event = "WinEnter",
  },
  ["pocco81/truezen.nvim"] = {
    cmd = {
      "TZMinimalist",
      "TZFocus",
      "TZAtaraxis",
      "TZBottom",
      "TZTop",
      "TZLeft",
    },
  },
  ["nacro90/numb.nvim"] = {
    config = config.numb,
    event = "BufReadPost",
  },
  ["winston0410/range-highlight.nvim"] = {
    requires = { "winston0410/cmd-parser.nvim", opt = true },
    config = config.range_highlight,
    event = "BufReadPost",
  },
  ["rcarriga/nvim-notify"] = {
    config = config.notify,
  },
  ["machakann/vim-highlightedyank"] = {
    event = "BufReadPost",
  },
  ["p00f/nvim-ts-rainbow"] = {
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
    event = "BufReadPost",
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    config = config.indent_blankline,
    event = "BufReadPost",
  },
  ["kevinhwang91/nvim-bqf"] = {
    ft = "qf",
    config = config.bqf,
    setup = config.setup_bqf,
  },
  ["folke/trouble.nvim"] = {
    event = "CmdlineEnter",
    config = config.trouble,
  },
  ["liuchengxu/vista.vim"] = {
    config = config.vista,
    event = "CmdlineEnter",
  },
  ["norcalli/nvim-colorizer.lua"] = {
    config = config.colorizer,
    event = "BufReadPost",
  },
  ["stevearc/dressing.nvim"] = {
    config = config.dressing,
    event = "BufReadPost",
  },
  ["kristijanhusak/vim-dadbod-ui"] = {
    event = "CmdlineEnter",
  },
}
return ui
