local M = {
  servers = {
    go = "gopls",
    cpp = "ccls",
    cmake = "cmake",
    css = "cssls",
    html = "html",
    javascript = "tssserver",
    eslint = "eslint",
    bash = "bashls",
    sql = "sqlls",
    lua = "sumneko_lua",
    vim = "vimls",

    json = "jsonls",
    toml = "taplo",
    xml = "lemminx",
    yaml = "yamlls",
    docker = "dockerls",
    dot = "dotls",
  },
  opts = {},
  keymaps = {},
  commands = {},
}

--
-- sumneko_lua configuration
--
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

M.opts.sumneko_lua = {
  settings = {
    Lua = {
      workspace = {
        ignoreDir = { ".undo" },
      },
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = { "vim", "use" },
        disable = { "lowercase-global" },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

--
-- ccls configuration
--
-- TODO: Cached in standard vim cache dir
M.opts.ccls = {
  init_options = {
    cache = {
      directory = ".cache/ccls-cache",
    },
    index = {
      -- comments = 2,
      comments = 1,
    },
    compilationDatabaseDirectory = "Build",
  },
}

-- Find callers or callees when the cursor is at a function.
-- Arguments
--     callee:
--         true: Outgoing calls
--         false: Incoming calls
-- TODO: support calltype and levels
function ccls_call(callee, calltype, levels)
  local params = vim.lsp.util.make_position_params()
  params.callee = callee
  vim.lsp.buf_request(
    0,
    "$ccls/call",
    params,
    vim.lsp.handlers["textDocument/references"]
  )
end

-- Finds all variables when the cursor is at a type of a variable.
--
-- Arugments:
--     kind:
-- 	       nil: all variables
-- 	       2: local variables
-- 	       4: arguments
function ccls_var(kind)
  local params = vim.lsp.util.make_position_params()
  params.kind = kind
  vim.lsp.buf_request(
    0,
    "$ccls/vars",
    params,
    vim.lsp.handlers["textDocument/references"]
  )
end

-- Find base classes or derived classes.
--
-- Arguments:
--     derived:
--         true: derived classes
--     		 false: base classes
-- TODO: support levels
function ccls_inheritance(derived)
  local params = vim.lsp.util.make_position_params()
  params.derived = derived
  vim.lsp.buf_request(
    0,
    "$ccls/inheritance",
    params,
    vim.lsp.handlers["textDocument/references"]
  )
end

-- Find member variables/functions/types when the cursor is at a class/struct/union or a variable (the type of which will be used).
-- Find local variables when the cursor is at a function.
--
-- Arguments:
--     kind:
--         4: member variables are returned.
--         3: member functions are returned.
--         2: member types are returned.
function ccls_member(kind)
  local params = vim.lsp.util.make_position_params()
  params.kind = kind
  vim.lsp.buf_request(
    0,
    "$ccls/member",
    params,
    vim.lsp.handlers["textDocument/references"]
  )
end

-- FIXME: VarLocal finds global variable
M.commands.ccls = {
  {
    name = "Derived",
    command = function()
      ccls_inheritance(true)
    end,
  },
  {
    name = "Base",
    command = function()
      ccls_inheritance(false)
    end,
  },
  {
    name = "VarAll",
    command = function()
      ccls_var()
    end,
  },
  {
    name = "VarLocal",
    command = function()
      ccls_var(2)
    end,
  },
  {
    name = "VarArg",
    command = function()
      ccls_var(4)
    end,
  },
  {
    name = "MemberFunction",
    command = function()
      ccls_member(3)
    end,
  },
  {
    name = "MemberType",
    command = function()
      ccls_member(2)
    end,
  },
  {
    name = "MemberVar",
    command = function()
      ccls_member(4)
    end,
  },
  {
    name = "Callers",
    command = function()
      ccls_call(false)
    end,
  },
  {
    name = "Callees",
    command = function()
      ccls_call(true)
    end,
  },
}

return M
