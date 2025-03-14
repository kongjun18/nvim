local M = {}

vim.env.GOLANGCI_LINT_RUNNER_CPUS = "1"

M.opts = {
  -- Run golangci_lint on a single file to reduce CPU/MEM consuming.
  extra_args = {"--fast"},
}

return M
