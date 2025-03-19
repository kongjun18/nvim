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
    tag = "legacy",
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
  ["nacro90/numb.nvim"] = {
    config = config.numb,
    event = "VeryLazy",
  },
  ["rcarriga/nvim-notify"] = {
    config = config.notify,
    event = "VeryLazy",
  },
  ["machakann/vim-highlightedyank"] = {
    event = "VeryLazy",
  },
  ["HiPhish/rainbow-delimiters.nvim"] = {
    event = { "BufReadPost", "BufNewFile" },
    config = config.rainbow_delimiters,
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    config = config.indent_blankline,
    main = "ibl",
    event = {"BufReadPost", "BufNewFile"},
  },
  ["kevinhwang91/nvim-bqf"] = {
    config = config.bqf,
    event = "VeryLazy",
  },
  ["folke/trouble.nvim"] = {
    config = config.trouble,
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
  ["yorickpeterse/nvim-pqf"] = {
    config = config.pqf,
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
