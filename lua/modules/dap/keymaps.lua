local M = {
  ["<F6>"] = {
    ":lua require'dap'.toggle_breakpoint()<CR>",
    "Toggle Breakpoint",
  },
  ["<Leader><F6>"] = {
    ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    "Toggle Conditional Breakpoint",
  },
  ["<F3>"] = { "<Cmd>lua require'dap'.continue()<CR>", "Continue" },
  ["<F9>"] = { "<Cmd>lua require'dap'.step_into()<CR>", "Step Into" },
  ["<F10>"] = { "<Cmd>lua require'dap'.step_over()<CR>", "Step Over" },
  ["<F8>"] = { "<Cmd>lua require'dap'.step_out()<CR>", "Step Out" },
  ["<C-S-F5>"] = { "<Cmd>lua require'dap'.run_last()<CR>", "Restart Debug" },
  ["<F1>"] = {
    function()
      require("dap").close()
      require("dap.repl").close()
      require("dapui").close()
      vim.cmd("DapVirtualTextForceRefresh")
    end,
    "Exit Debug",
  },
}
-- Evaluate expression
vim.keymap.set(
  { "n", "v" },
  "<M-k>",
  ":lua require('dapui').eval()<CR>",
  { silent = true }
)
return M
