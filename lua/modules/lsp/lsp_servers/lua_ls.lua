--
-- lua_ls configuration
--
local M = {}
require("neodev").setup({
  library = {
    plugins = false,
  },
})

M.opts = {
  -- Disable lua-language-server format
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    Lua = {
      workspace = {
        ignoreDir = { ".undo" },
      },
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = {
          "vim",
          "os_name",
          "is_linux",
          "is_windows",
          "config_dir",
          "cache_dir",
          "data_dir",
          "home",
          "path_sep",
          "modules_dir",
          "core_dir",
          "lazy_dir",
          "backup_dir",
          "swap_dir",
          "undo_dir",
          "session_dir",
          "dict_dir",
          "path",
          "t"
        },
        disable = { "lowercase-global" },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

return M
