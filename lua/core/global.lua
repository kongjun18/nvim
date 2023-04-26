os_name = vim.loop.os_uname().sysname
is_linux = os_name == "Linux"
is_windows = os_name == "Windows_NT"
config_dir = vim.fn.stdpath("config")
cache_dir = vim.fn.stdpath("cache")
data_dir = vim.fn.stdpath("data")
home = is_linux and os.getenv("HOME") or os.getenv("USERPROFILE")
path_sep = is_windows and "\\" or "/"
modules_dir = table.concat({ config_dir, "lua", "modules" }, path_sep)
core_dir = table.concat({ config_dir, "lua", "core" }, path_sep)
lazy_dir = table.concat({ data_dir, "lazy" }, path_sep)
backup_dir = data_dir .. path_sep .. "backup"
swap_dir = data_dir .. path_sep .. "swap"
undo_dir = data_dir .. path_sep .. "undo"
session_dir = data_dir .. path_sep .. "session"
dict_dir = config_dir .. path_sep .. "dict"

function path(...)
  return table.concat({ ... }, path_sep)
end

function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
