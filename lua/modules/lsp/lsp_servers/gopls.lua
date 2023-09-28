--
-- gopls configuration
--
local M = {}

M.opts = require("go.lsp").config({
  setting = {
    gopls = {
      ["completeFunctionCalls"] = false,
    },
  },
})
M.opts.capabilities.textDocument.completion.completionItem.snippetSupport =
  false

vim.api.nvim_create_augroup("Go", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format Go code on save",
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
})

return M
