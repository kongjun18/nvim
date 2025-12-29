local M = {}
M.keymaps = require("modules.editor.keymaps")
M.config = require("modules.editor.config")
M.plugins = require("modules.editor.plugins")
require("modules.editor.autocmd")
return M
