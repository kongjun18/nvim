local M = {}

M.linters = {
  sh = { "shellcheck" },
  go = { "golangcilint" },
  cpp = { "cppcheck" },
  -- lua = { "luacheck" },
  javascript = { "eslint" },
  dockerfile = { "hadolint" },
}
M.opts = {}

return M
