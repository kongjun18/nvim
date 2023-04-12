local M = {}

M.providers = {
  cpp = "clang_format",
  lua = "stylua",
  cmake = "cmake_format",
  json = "fixjson",
  sql = "sqlformat",
  web = "prettier", -- javascript/html/ccs
}

M.opts = {}

return M
