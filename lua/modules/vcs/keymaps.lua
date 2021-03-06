local vcs = {
  ["]c"] = {
    function()
      return vim.api.nvim_win_get_option(0, "diff") and "]c"
        or t("<Cmd>Gitsigns next_hunk<CR>")
    end,
    "Next Difference",
    expr = true,
  },
  ["[c"] = {
    function()
      return vim.api.nvim_win_get_option(0, "diff") and "[c"
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
      "Stage Hunk",
    },
    ["r"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
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
  -- Map in different modes
  ["ghs"] = {
    function()
      require("gitsigns").stage_hunk()
    end,
    "Stage Hunk",
    mode = "v",
  },
  ["ghr"] = {
    function()
      require("gitsigns").reset_hunk()
    end,
    "Reset Hunk",
    mode = "v",
  },
  -- which-key.nvim only maps one mode mapping
  ["i"] = {
    ["h"] = {
      "<Cmd>:<C-U>Gitsigns select_hunk<CR>",
      "Inner Hunk",
      mode = "o",
    },
  },
  ["ih"] = { "<Cmd>:<C-U>Gitsigns select_hunk<CR>", "Inner Hunk", mode = "x" },
}

return vcs
