local vcs = {
  ["]ob"] = {
    function ()
      require("gitsigns").toggle_current_line_blame(false)
    end,
    "Close Inline Git Blame",
  },
  ["[ob"] = {
    function ()
      require("gitsigns").toggle_current_line_blame(true)
    end,
    "Open Inline Git Blame",
  },
  ["]c"] = {
    function()
      return vim.api.nvim_get_option_value("diff", { win = 0 }) and "]c"
        or t("<Cmd>Gitsigns next_hunk<CR>")
    end,
    "Next Difference",
    expr = true,
  },
  ["[c"] = {
    function()
      return vim.api.nvim_get_option_value("diff", { win = 0 }) and "[c"
        or t("<Cmd>Gitsigns prev_hunk<CR>")
    end,
    "Previous Difference",
    expr = true,
  },
  ["gh"] = {
    ["name"] = "+Git Actions",
    ["s"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      mode = { "n", "v" },
      "Stage Hunk",
    },
    ["r"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      mode = { "n", "v" },
      "Reset Hunk",
    },
    ["S"] = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "Stage Buffer",
    },
    ["R"] = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "Reset Buffer",
    },
    ["u"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo Stage Hunk",
    },
    ["p"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview Hunk",
    },
    ["b"] = {
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      "Blame Line",
    },
    ["d"] = {
      function()
        require("gitsigns").diffthis()
      end,
      "Diff Against The Index",
    },
    ["D"] = {
      function()
        require("gitsigns").diffthis("~")
      end,
      "Diff Against The Last Commit",
    },
  },
  ["i"] = {
    ["h"] = {
      ":<C-U>Gitsigns select_hunk<CR>",
      mode = { "o", "x" },
      "Inner Hunk",
    },
  },
}

return vcs
