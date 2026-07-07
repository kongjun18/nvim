local core = {}
require("core.global")

pcall(require, "local")

require("core.autocmd")
core.options = require("core.options")
core.keymaps = require("core.keymaps")
core.statuscolumn = require("core.statuscolumn")

return core
