-- NOTE: DAPInstall.nvim only supports Unix
local dap = {
  ["mfussenegger/nvim-dap"] = {
    config = config.dap,
  },
  ["Pocco81/DAPInstall.nvim"] = {
    config = config.dapinstall,
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    config = config.dap_virtual_text,
  },
  ["rcarriga/nvim-dap-ui"] = {
    config = config.dap_ui,
  },
}

return dap
