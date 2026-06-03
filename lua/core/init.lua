local core = {}
require("core.global")

local function configure_environment()
  local local_lua = config_dir .. path_sep .. "lua" .. path_sep .. "local.lua"
  if vim.loop.fs_stat(local_lua) then
    return
  end
  local handle = io.popen("ctags --version 2>&1")
  local output = handle and handle:read("*a") or ""
  if handle then
    handle:close()
  end
  local flavor = output:find("Universal Ctags") and "universal" or "emacs"
  local f = io.open(local_lua, "w")
  if f then
    f:write('ctags_flavor = "' .. flavor .. '"\n')
    f:close()
  end
end

configure_environment()
pcall(require, "local")

require("core.autocmd")
core.options = require("core.options")
core.keymaps = require("core.keymaps")
core.statuscolumn = require("core.statuscolumn")

return core
