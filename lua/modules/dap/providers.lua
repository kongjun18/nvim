local M = {}
M.adapters = {}
M.configurations = {}

local function exepath(exe, default_path)
  local path = vim.fn.exepath(exe)
  return #path == 0 and path or default_path
end

local function load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(
    ok,
    string.format("dap-go dependency error: %s not installed", module_name)
  )
  return module
end

local function arguments()
  local args_string = vim.fn.input("Arguments: ")
  return vim.split(args_string, " ")
end

local dap = load_module("dap")

--
-- lldb-vscode
--
function setup_cpp_adapter(dap)
  dap.adapters.lldb = {
    type = "executable",
    command = exepath("lldb-vscode", "/usr/bin/lldb-vscode-14"), -- adjust as needed, must be absolute path
    name = "lldb",
  }
end

function setup_cpp_configuration(dap)
  dap.configurations.cpp = {
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
end

--
-- dlve
--
local function setup_go_adapter(dap)
  dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
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
      handle:close()
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
          vim.fn.expand("%:p:r"),
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

setup_go_adapter(dap)
setup_go_configuration(dap)
setup_cpp_adapter(dap)
setup_cpp_configuration(dap)

return M
