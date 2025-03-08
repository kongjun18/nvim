local M = {}

M.opts = {
  compilationDatabaseDirectory = "build",
  cache = {
    directory = ".cache/clangd",
  },
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
}

return M
