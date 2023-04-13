local M = {}

vim.api.nvim_create_augroup("Markdown", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format markdown file on save",
  pattern = "*.md",
  callback = function()
    vim.lsp.buf.format()
  end,
})

return M
