local M = {}
M.adapters = {}
M.configurations = {}

local function exepath(...)
  for _, executable in ipairs({ ... }) do
    local path = vim.fn.exepath(executable)
    if #path ~= 0 then
      return path
    end
  end
end

local function arguments()
  local args_string = vim.fn.input("Arguments: ")
  return vim.split(args_string, " ")
end

local DAP = require("dap")

--
-- lldb-vscode
--
local function setup_lldb_vscode(dap)
  dap.adapters.lldb = {
    type = "executable",
    command = exepath("lldb-vscode", "/usr/bin/lldb-vscode-14"), -- adjust as needed, must be absolute path
    name = "lldb",
  }
end

local function setup_cpp_configuration(dap)
  local cpp_config = {
    {
      name = "Launch executable",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input(
          "Path to executable: ",
          ---@diagnostic disable-next-line: redundant-parameter
          vim.fn.expand("%:p:r") .. ".out",
          ---@diagnostic disable-next-line: redundant-parameter
          "file"
        )
      end,
      preRunCommands = "break main",
      args = arguments,
    },
    {
      -- If you get an "Operation not permitted" error using this, try disabling YAMA:
      --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      name = "Attach to process",
      type = "lldb",
      request = "attach",
      pid = require("dap.utils").pick_process,
    },
  }
  dap.configurations.cpp = cpp_config
  dap.configurations.c = cpp_config
end

--
-- dlve
--
local function setup_go_adapter(dap)
  dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    if not stdout then
      vim.notify_once(
        "DAP adapter dlv fails to new pipe stdout",
        vim.log.levels.WARN
      )
      return
    end
    local handle
    local pid_or_err
    local host = config.host or "127.0.0.1"
    local port = config.port or "38697"
    local addr = string.format("%s:%s", host, port)
    local opts = {
      stdio = { nil, stdout },
      args = { "dap", "-l", addr },
      detached = true,
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      if handle then
        handle:close()
      end
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end)
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
      callback({ type = "server", host = "127.0.0.1", port = port })
    end, 100)
  end
end

local function setup_go_configuration(dap)
  dap.configurations.go = {
    {
      type = "go",
      name = "Execute Precompiled Binary",
      mode = "exec",
      request = "launch",
      program = function()
        return vim.fn.input(
          "Path to executable: ",
          ---@diagnostic disable-next-line: redundant-parameter
          vim.fn.expand("%:p:r"),
          ---@diagnostic disable-next-line: redundant-parameter
          "file"
        )
      end,
      args = arguments,
    },
    {
      type = "go",
      name = "Debug Package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require("dap.utils").pick_process,
    },
  }
end

setup_go_adapter(DAP)
setup_lldb_vscode(DAP)

setup_go_configuration(DAP)
setup_cpp_configuration(DAP)

return M
