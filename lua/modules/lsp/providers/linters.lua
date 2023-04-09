local M = {}

M.providers = {
  sh = "shellcheck",
  go = "golangci_lint",
  cpp = "cppcheck",
  javascript = "eslint",
  dockerfile = "hadolint",
  lua = "luacheck",
}
M.opts = {}

return M
