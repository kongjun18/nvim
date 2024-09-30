local vcs = {
  {
    "]ob",
    function()
      require("gitsigns").toggle_current_line_blame(false)
    end,
    desc = "Close Inline Git Blame",
  },
  {
    "[ob",
    function()
      require("gitsigns").toggle_current_line_blame(true)
    end,
    desc = "Open Inline Git Blame",
  },
  {
    "]c",
    function()
      return vim.api.nvim_get_option_value("diff", { win = 0 }) and "]c"
        or "<Cmd>Gitsigns next_hunk<CR>"
    end,
    desc = "Next Difference",
    expr = true,
  },
  {
    "[c",
    function()
      return vim.api.nvim_get_option_value("diff", { win = 0 }) and "[c"
        or "<Cmd>Gitsigns prev_hunk<CR>"
    end,
    desc = "Previous Difference",
    expr = true,
  },
  {
    { "gh", group = "+Git Actions" },
    {
      "ghs",
      function()
        require("gitsigns").stage_hunk()
      end,
      mode = { "n", "v" },
      desc = "Stage Hunk",
    },
    {
      "ghr",
      function()
        require("gitsigns").reset_hunk()
      end,
      mode = { "n", "v" },
      desc = "Reset Hunk",
    },
    {
      "ghS",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "Stage Buffer",
    },
    {
      "ghR",
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = "Reset Buffer",
    },
    {
      "ghu",
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      desc = "Undo Stage Hunk",
    },
    {
      "ghp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview Hunk",
    },
    {
      "ghb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Blame Line",
    },
    {
      "ghd",
      function()
        require("gitsigns").diffthis()
      end,
      desc = "Diff Against The Index",
    },
    {
      "ghD",
      function()
        require("gitsigns").diffthis("~")
      end,
      desc = "Diff Against The Last Commit",
    },
  },
  {
    "ih",
    ":<C-U>Gitsigns select_hunk<CR>",
    mode = { "o", "x" },
    desc = "Inner Hunk",
  },
}

return vcs
