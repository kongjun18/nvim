local M = {}

M.opts = {
  -- Run golangci_lint on a single file to reduce CPU/MEM consuming.
  extra_args = { "--fast" },
}

return M
