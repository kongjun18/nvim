local config = require("modules.ui.config")
local ui = {
  ["nvim-tree/nvim-tree.lua"] = {
    config = config.nvim_tree,
    event = "VeryLazy",
  },
  ["EdenEast/nightfox.nvim"] = {
    lazy = false,
    config = config.nightfox,
    priority = 1000,
    build = ":NightfoxCompile",
  },
  ["j-hui/fidget.nvim"] = {
    config = config.fidget,
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
  },
  ["nvim-lualine/lualine.nvim"] = {
    event = "VeryLazy",
    config = config.lualine,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
  },
  ["camspiers/animate.vim"] = {
    event = "VeryLazy",
  },
  ["camspiers/lens.vim"] = {
    config = config.lens,
    event = "VeryLazy",
    dependencies = { "animate.vim" },
  },
  ["Pocco81/truezen.nvim"] = {
    event = "VeryLazy",
  },
  ["nacro90/numb.nvim"] = {
    config = config.numb,
    event = "VeryLazy",
  },
  ["winston0410/range-highlight.nvim"] = {
    event = "VeryLazy",
    dependencies = { "winston0410/cmd-parser.nvim" },
    config = config.range_highlight,
  },
  ["rcarriga/nvim-notify"] = {
    config = config.notify,
    event = "VeryLazy",
  },
  ["machakann/vim-highlightedyank"] = {
    event = "VeryLazy",
  },
  ["HiPhish/nvim-ts-rainbow2"] = {
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    config = config.indent_blankline,
    event = "VeryLazy",
  },
  ["kevinhwang91/nvim-bqf"] = {
    config = config.bqf,
    event = "VeryLazy",
  },
  ["folke/trouble.nvim"] = {
    config = config.trouble,
    event = "VeryLazy",
  },
  ["liuchengxu/vista.vim"] = {
    config = config.vista,
    event = "VeryLazy",
  },
  ["norcalli/nvim-colorizer.lua"] = {
    config = config.colorizer,
    event = "VeryLazy",
  },
  ["stevearc/dressing.nvim"] = {
    config = config.dressing,
    event = "VeryLazy",
  },
  ["kristijanhusak/vim-dadbod-ui"] = {
    ft = "qf",
  },
  ["https://gitlab.com/yorickpeterse/nvim-pqf"] = {
    config = config.pqf,
    event = "VeryLazy",
  },
  ["nyngwang/murmur.lua"] = {
    config = config.murmur,
    event = "VeryLazy",
  },
  ["utilyre/barbecue.nvim"] = {
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = config.barbecue,
  },
}
return ui
