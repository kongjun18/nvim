local M = {}
-- NOTE: null-ls is disable in C/C++ buffer
M.linters = {
  sh = "shellcheck",
  cpp = "cppcheck",
  lua = "luacheck",
  javascript = "eslint",
  docker = "hadolint",
}
M.opts = {}

-----------------------------------------------------------------------
-- Use hadolint in docker
-- Bash script(/usr/local/bin/hadolint):
--
-- #!/bin/bash
-- dockerfile="$1"
-- shift
-- docker run --rm -i hadolint/hadolint hadolint "$@" - < "$dockerfile"
-----------------------------------------------------------------------
-- I don't know why this configuration works, but it works.
M.opts.hadolint = {
  args = { "$FILENAME", "--no-fail", "--format=json" },
}

return M
