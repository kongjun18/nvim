local M = {}

-- TODO: make sure configuration works perfectly without LSP
M.modules = { "ui", "editor", "lsp", "vcs", "dap" }
M.packer = require("core.packer")

require("modules.custom")
for _, module in pairs(M.modules) do
  local m = require("modules/" .. module)
  M.packer:load(m.plugins)
end

if M.packer.bootstrap then
  M.packer.packer.sync()
end

while require("core.packer").bootstrap do
  vim.wait(200, function()
    return not require("core.packer").bootstrap
  end)
end

pcall(require, "packer_compiled")

local wk = require("which-key")
for _, module in pairs(M.modules) do
  local m = require("modules/" .. module)
  if m.keymaps then
    wk.register(m.keymaps)
  end
end

return M
