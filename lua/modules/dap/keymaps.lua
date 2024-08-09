local M = {
  {
    "<leader>w<F6>",
    ":lua require'dap'.toggle_breakpoint()<CR>",
    desc = "Toggle Breakpoint",
  },
  {
    "<leader>w<Leader><F6>",
    function()
      local condition = vim.fn.input("Breakpoint condition: ")
      if condition ~= "" then
        require("dap").set_breakpoint(condition)
      end
    end,
    desc = "Toggle Conditional Breakpoint",
  },
  {
    "<leader>w<F3>",
    "<Cmd>lua require'dap'.continue()<CR>",
    desc = "Continue",
  },
  {
    "<leader>w<F9>",
    "<Cmd>lua require'dap'.step_into()<CR>",
    desc = "Step Into",
  },
  {
    "<leader>w<F10>",
    "<Cmd>lua require'dap'.step_over()<CR>",
    desc = "Step Over",
  },
  {
    "<leader>w<F8>",
    "<Cmd>lua require'dap'.step_out()<CR>",
    desc = "Step Out",
  },
  {
    "<leader>w<C-S-F5>",
    "<Cmd>lua require'dap'.run_last()<CR>",
    desc = "Restart Debug",
  },
  {
    "<leader>w<F1>",
    function()
      require("dap").close()
      require("dap.repl").close()
      require("dapui").close()
      vim.cmd("DapVirtualTextForceRefresh")
    end,
    desc = "Exit Debug",
  },
}

return M
