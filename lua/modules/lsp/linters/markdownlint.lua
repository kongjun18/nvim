local M = {}

M.opts = {
  -- MD041 first-line-heading/first-line-h1 - First line in a file should be a top-level heading
  extra_args = { "--disable", "MD041", "--" },
}

return M
