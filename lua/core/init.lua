-- TODO: add custom functions
-- TODO: add comments
local core = {}

core.global = require("core.global")
core.options = require("core.options")
core.keymapgs = require("core.keymaps")
vim.cmd(
  string.format(
    "source %s",
    core.global.core_dir .. core.global.path_sep .. "autocmd.vim"
  )
)

return core
