-- TODO: add custom functions
-- TODO: add comments
local core = {}
require("core.global")
require("core.autocmd")
core.options = require("core.options")
core.keymapgs = require("core.keymaps")
core.statuscolumn = require("core.statuscolumn")

return core
