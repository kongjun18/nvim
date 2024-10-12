local M = {
  {
    { "<Leader>w", group = "+window" },
    { "<leader>wo", "<C-w>o", desc = "Open Window" },
    -- <leader>wc overlaps with <leader>wc*
    { "<leader>wcc", "<C-w>c", desc = "Close Window" },
    { "<leader>wq", "<C-w>c", desc = "Quit Window" },
    {
      "<leader>wcj",
      function()
        require("modules.ui.window").close_window("j")
      end,
      desc = "Close Below Window",
    },
    {
      "<leader>wck",
      function()
        require("modules.ui.window").close_window("k")
      end,
      desc = "Close Above Window",
    },
    {
      "<leader>wch",
      function()
        require("modules.ui.window").close_window("h")
      end,
      desc = "Close Left Window",
    },
    {
      "<leader>wcl",
      function()
        require("modules.ui.window").close_window("l")
      end,
      desc = "Close Right Window",
    },

    { "<leader>whc", ":hide<CR>", desc = "Hide Window" },
    {
      "<leader>whk",
      function()
        require("modules.ui.window").hide_window("k")
      end,
      desc = "Hide Below Window",
    },
    {
      "<leader>whj",
      function()
        require("modules.ui.window").hide_window("j")
      end,
      desc = "Hide Above Window",
    },
    {
      "<leader>whh",
      function()
        require("modules.ui.window").hide_window("h")
      end,
      desc = "Hide Left Window",
    },
    {
      "<leader>whl",
      function()
        require("modules.ui.window").hide_window("l")
      end,
      desc = "Hide Right Window",
    },

    { "<leader>wH", "<C-w>H", desc = "Move Window To The Left Side" },
    { "<leader>wJ", "<C-w>L", desc = "Move Window To The Right Side" },
    { "<leader>wL", "<C-w>J", desc = "Move Window To The Button Side" },
    { "<leader>wK", "<C-w>K", desc = "Move Window To The Upper Side" },

    { "<leader>wv", "<C-w>v", desc = "Vertical Split Current Window" },
    { "<leader>ws", "<C-w>s", desc = "Split Current Window" },
    { "<leader>wt", "<C-w>T", desc = "Move Window To New Tab" },

    { "<leader>w-", "<C-w>-", desc = "Decrease Current Window Height" },
    { "<leader>w=", "<C-w>+", desc = "Increase Current Window Height" },
    { "<leader>w,", "<C-w><", desc = "Decrease Current Window Width" },
    { "<leader>w.", "<C-w>>", desc = "Increase Current Window Width" },
  },

  {
    { "<leader>b", group = "+buffer" },
    { "<leader>dd", ":bdelete<CR>", desc = "Delete Buffer" },
  },

  {
    {
      "<M-m>",
      function()
        require("modules.ui.window").scroll_adjacent_window("down")
      end,
      desc = "Scroll Adjacent Window Down",
    },
    {
      "<M-p>",
      function()
        require("modules.ui.window").scroll_adjacent_window("up")
      end,
      desc = "Scroll Adjacent Window Up",
    },

    {
      "<M-u>",
      function()
        require("modules.ui.window").scroll_quickfix("up")
      end,
      desc = "Scroll Quickfix Up",
    },
    {
      "<M-d>",
      function()
        require("modules.ui.window").scroll_quickfix("down")
      end,
      desc = "Scroll Quickfix Down",
    },
  },

  {
    { "<leader>t", group = "+tree/translate" },
    {
      "<leader>tt",
      ":lua require('nvim-tree.api').tree.toggle({focus = false})<CR>",
      desc = "Toggle NvimTree",
    },
    { "<leader>to", ":NvimTreeOpen<CR>", desc = "Open NvimTree" },
    { "<leader>tc", ":NvimTreeClose<CR>", desc = "Close NvimTree" },
    {
      "<leader>tq",
      function()
        require("modules.ui.window").close_buffers()
      end,
      desc = "Quit Tab",
    },
  },
}

return M
