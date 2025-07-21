local M = {}
require("core.global")

M.ft_blacklist = { "qf", "notify", "NvimTree", "Outline" }
M.bt_blacklist = {}

M.diary_path = path(home, "Obsidian", "06-日记", "日记.md")

return M
