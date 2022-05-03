local config = {}

function config.nvim_dap()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end
  -- GlobalPacker:ensure_loaded("nvim-dap-ui")
  vim.cmd("PackerLoad nvim-dap-ui")
  -- Toggle dap ui automatically
  local dapui = require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    dap.repl.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    dap.repl.close()
  end
  -- Set breakpoint icon
  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "⊚", texthl = "TodoFgFIX", linehl = "", numhl = "" }
  )
  -- Load dap configurations
  local daps = require("modules.dap.providers")
  for name, opt in pairs(daps) do
    dap.adapters[name] = opt.adapters
    dap.configurations[name] = opt.configurations
  end
end

function config.nvim_dap_virtual_text()
  GlobalPacker:setup("nvim-dap-virtual-text")
end

function config.nvim_dap_go()
  GlobalPacker:setup("dap-go")
end

function config.nvim_dap_ui()
  GlobalPacker:setup("dapui", {
    sidebar = {
      position = "right",
    },
    theme = false, -- Disable default color
    render = {
      max_type_length = 0, -- Hide type
    },
  })
end

return config
