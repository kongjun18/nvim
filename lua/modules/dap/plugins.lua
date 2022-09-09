local config = require("modules.dap.config")
local dap = {
  ["mfussenegger/nvim-dap"] = {
    config = config.nvim_dap,
    requires = {
      {
        "rcarriga/nvim-dap-ui",
        opt = true,
        config = config.nvim_dap_ui,
      },
    },
    event = "CmdlineEnter",
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    config = config.nvim_dap_virtual_text,
    after = "nvim-dap",
  },
}

return dap
