local M = {}

local function exepath(exe, default_path)
  local path = vim.fn.exepath(exe)
  return #path == 0 and path or default_path
end

M.adapters = {
  lldb = {
    type = "executable",
    command = exepath("lldb-vscode", "/usr/bin/lldb-vscode-14"), -- adjust as needed, must be absolute path
    name = "lldb",
  },
}
M.configurations = {
  cpp = {
    {
      name = "Launch executable",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input(
          "Path to executable: ",
          vim.fn.expand("%:p:r") .. ".out",
          "file"
        )
      end,
      cwd = "${workspaceFolder}",
      preRunCommands = "break main",
      args = {},
    },
    {
      -- If you get an "Operation not permitted" error using this, try disabling YAMA:
      --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      name = "Attach to process",
      type = "lldb",
      request = "attach",
      pid = require("dap.utils").pick_process,
      args = {},
    },
  },
}
return M
