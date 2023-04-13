local M = {}

vim.api.nvim_create_augroup("Markdown", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format Go code on save",
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format()
  end,
})

return M
