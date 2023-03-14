local config = require("modules.dap.config")
local dap = {
  ["mfussenegger/nvim-dap"] = {
    config = config.nvim_dap,
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = config.nvim_dap_ui,
        event = "VeryLazy",
      },
    },
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    config = config.nvim_dap_virtual_text,
    dependencies = { "nvim-dap" },
  },
}

return dap
