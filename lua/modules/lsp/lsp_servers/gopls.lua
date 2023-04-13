--
-- gopls configuration
--
local M = {}

M.opts = require("go.lsp").config()

vim.api.nvim_create_augroup("Go", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format Go code on save",
  pattern = "*.go",
  callback = function()
    local ok, format = pcall(require, "go.format")
    if ok then
      format.goimport()
    end
  end,
})

return M
