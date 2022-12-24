local M = {
  ["<Leader>w"] = {
    ["name"] = "+window",

    ["o"] = { "<C-w>o", "Open Window" },
    ["c"] = { "<C-w>c", "Close Window" },
    ["q"] = { "<C-w>c", "Quit Window" },
    ["cj"] = {
      function()
        require("modules.ui.window").close_window("j")
      end,
      "Close Below Window",
    },
    ["ck"] = {
      function()
        require("modules.ui.window").close_window("k")
      end,
      "Close Above Window",
    },
    ["ch"] = {
      function()
        require("modules.ui.window").close_window("h")
      end,
      "Close Left Window",
    },
    ["cl"] = {
      function()
        require("modules.ui.window").close_window("l")
      end,
      "Close Right Window",
    },

    ["hc"] = { ":hide<CR>", "Hide Window" },
    ["hk"] = {
      function()
        require("modules.ui.window").hide_window("k")
      end,
      "Hide Below Window",
    },
    ["hj"] = {
      function()
        require("modules.ui.window").hide_window("j")
      end,
      "Hide Above Window",
    },
    ["hh"] = {
      function()
        require("modules.ui.window").hide_window("h")
      end,
      "Hide Left Window",
    },
    ["hl"] = {
      function()
        require("modules.ui.window").hide_window("l")
      end,
      "Hide Right Window",
    },

    ["H"] = { "<C-w>H", "Move Window To The Left Side" },
    ["J"] = { "<C-w>J", "Move Window To The Right Side" },
    ["L"] = { "<C-w>L", "Move Window To The Button Side" },
    ["K"] = { "<C-w>K", "Move Window To The Upper Side" },

    ["v"] = { "<C-w>v", "Vertical Split Current Window" },
    ["s"] = { "<C-w>s", "Split Current Window" },
    ["t"] = { "<C-w>T", "Move Window To New Tab" },

    ["-"] = { "<C-w>-", "Decrease Current Window Height" },
    ["="] = { "<C-w>+", "Increase Current Window Height" },
    [","] = { "<C-w><", "Decrease Current Window Width" },
    ["."] = { "<C-w>>", "Increase Current Window Width" },
  },

  ["<leader>b"] = {
    ["name"] = "+buffer",
    ["d"] = { ":bdelete<CR>", "Delete Buffer" },
  },

  ["<Leader><Tab>"] = {
    function()
      local in_blacklist =
        require("modules.ui.internal.bufferline").in_blacklist
      local alternate_buf = vim.fn.bufnr("#")
      if alternate_buf < 1 then
        return
      end
      if not (in_blacklist(alternate_buf) or in_blacklist(vim.fn.bufnr())) then
        return t("<C-^>")
      end
    end,
    expr = true,
    "Edit Alternate File",
  },
  ["<leader>-"] = { "gt<CR>", "Go To Next Tab" },
  ["<leader>="] = { "gT<CR>", "Go To Previos Tab" },
  ["<Leader>"] = {
    ["1"] = { "<Cmd>BufferLineGoToBuffer 1<CR>", "Go to Buffer 1" },
    ["2"] = { "<Cmd>BufferLineGoToBuffer 2<CR>", "Go to Buffer 2" },
    ["3"] = { "<Cmd>BufferLineGoToBuffer 3<CR>", "Go to Buffer 3" },
    ["4"] = { "<Cmd>BufferLineGoToBuffer 4<CR>", "Go to Buffer 4" },
    ["5"] = { "<Cmd>BufferLineGoToBuffer 5<CR>", "Go to Buffer 5" },
    ["6"] = { "<Cmd>BufferLineGoToBuffer 6<CR>", "Go to Buffer 6" },
    ["7"] = { "<Cmd>BufferLineGoToBuffer 7<CR>", "Go to Buffer 7" },
    ["8"] = { "<Cmd>BufferLineGoToBuffer 8<CR>", "Go to Buffer 8" },
    ["9"] = { "<Cmd>BufferLineGoToBuffer 9<CR>", "Go to Buffer 9" },
    ["$"] = { "Cmd>BufferLineGoToBuffer -1<CR>", "Go to Last Buffer" },
  },
  ["]"] = {
    ["b"] = { "<Cmd>BufferLineCycleNext<CR>", "Go to Next Buffer" },
  },
  ["["] = {
    ["b"] = { "<Cmd>BufferLineCyclePrev<CR>", "Go to Previous Buffer" },
  },
  ["<M-m>"] = {
    function()
      require("modules.ui.window").scroll_adjacent_window("down")
    end,
    "Scroll Adjacent Window Down",
  },
  ["<M-p>"] = {
    function()
      require("modules.ui.window").scroll_adjacent_window("up")
    end,
    "Scroll Adjacent Window Up",
  },

  ["<M-u>"] = {
    function()
      require("modules.ui.window").scroll_quickfix("up")
    end,
    "Scroll Quickfix Up",
  },
  ["<M-d>"] = {
    function()
      require("modules.ui.window").scroll_quickfix("down")
    end,
    "Scroll Quickfix Down",
  },

  ["<C-H>"] = { "<C-w>h", "Move Cursor To Left Window" },
  ["<C-L>"] = { "<C-w>l", "Move Cursor To Right Window" },
  ["<C-J>"] = { "<C-w>j", "Move Cursor To Window Below" },
  ["<C-K>"] = { "<C-w>k", "Move Cursor To Window Above" },

  ["<leader>t"] = {
    ["name"] = "+tree/translate",
    ["t"] = { ":NvimTreeToggle<CR>", "Toggle NvimTree" },
    ["o"] = { ":NvimTreeOpen<CR>", "Open NvimTree" },
    ["c"] = { ":NvimTreeClose<CR>", "Close NvimTree" },
    ["q"] = {
      function()
        require("modules.ui.window").close_buffers()
      end,
      "Quit Tab",
    },
  },
}

return M
