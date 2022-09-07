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
  -- Remap K to dap hover
  local api = vim.api
  local keymap_restore = {}
  dap.listeners.after["event_initialized"]["me"] = function()
    local overrided_keymaps = { "K", "<2-LeftMouse>" }
    for _, buf in pairs(api.nvim_list_bufs()) do
      local keymaps = api.nvim_buf_get_keymap(buf, "n")
      for _, keymap in pairs(keymaps) do
        if vim.tbl_contains(overrided_keymaps, keymap.lhs) then
          table.insert(keymap_restore, keymap)
          api.nvim_buf_del_keymap(buf, "n", keymap.lhs)
        end
      end
    end
    api.nvim_set_keymap(
      "n",
      "K",
      '<Cmd>lua require("dapui").eval()<CR>',
      { silent = true }
    )
    api.nvim_set_keymap(
      "n",
      "<2-LeftMouse>",
      '<Cmd>lua require("dapui").eval()<CR>',
      { silent = true }
    )
  end
  dap.listeners.after["event_terminated"]["me"] = function()
    for _, keymap in pairs(keymap_restore) do
      api.nvim_buf_set_keymap(
        keymap.buffer,
        keymap.mode,
        keymap.lhs,
        keymap.rhs,
        { silent = keymap.silent == 1, replace_keycodes = 1 }
      )
    end
    keymap_restore = {}
  end
  -- Set breakpoint icon
  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "●", texthl = "DapUIWatchesError" }
  )
  vim.fn.sign_define(
    "DapStopped",
    { text = "→", texthl = "DapUIBreakpointsCurrentLine", linehl = "debugPC" }
  )
  -- Load dap configurations
  local daps = require("modules.dap.providers")
  for name, opt in pairs(daps.adapters) do
    dap.adapters[name] = opt
  end
  for name, opt in pairs(daps.configurations) do
    dap.configurations[name] = opt
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
    layouts = {
      {
        elements = {
          { id = "breakpoints", size = 0.30 },
          { id = "scopes", size = 0.45 },
          { id = "watches", size = 0.25 },
        },
        size = 0.30,
        position = "right",
      },
      {
        elements = { "repl" },
        size = 0.30,
        position = "bottom",
      },
    },
    theme = false, -- Disable default color
    render = {
      max_type_length = 0, -- Hide type
    },
  })
end

return config
