local core = {}
require("core.global")
require("core.autocmd")
core.options = require("core.options")
core.keymaps = require("core.keymaps")
core.statuscolumn = require("core.statuscolumn")

return core
