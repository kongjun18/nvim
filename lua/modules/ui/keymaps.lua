local M = {
  ["<Leader>w"] = {
    ["name"] = "+window",

    ["o"] = {"<C-w>o", "Open Window"},
    ["c"] = {"<C-w>c", "Close Window"},
    ["cj"] = {function() require("modules.ui.window").close_window("j") end, "Close Below Window"},
    ["ck"] = {function() require("modules.ui.window").close_window("k") end, "Close Above Window"},
    ["ch"] = {function() require("modules.ui.window").close_window("h") end, "Close Left Window"},
    ["cl"] = {function() require("modules.ui.window").close_window("l") end, "Close Right Window"},

    ["hc"] = {":hide<CR>", "Hide Window"},
    ["hk"] = {function() require("modules.ui.window").hide_window("k") end, "Hide Below Window"},
    ["hj"] = {function() require("modules.ui.window").hide_window("j") end, "Hide Above Window"},
    ["hh"] = {function() require("modules.ui.window").hide_window("h") end, "Hide Left Window"},
    ["hl"] = {function() require("modules.ui.window").hide_window("l") end, "Hide Right Window"},

    ["H"] = {"<C-w>H", "Move Window To The Left Side"},
    ["J"] = {"<C-w>J", "Move Window To The Right Side"},
    ["L"] = {"<C-w>L", "Move Window To The Button Side"},
    ["K"] = {"<C-w>K", "Move Window To The Upper Side"},

    ["v"] = {"<C-w>v", "Vertical Split Current Window"},
    ["s"] = {"<C-w>s", "Split Current Window"},
    ["t"] = {"<C-w>T", "Move Window To New Tab"},


    ["-"] = {"<C-w>-", "Decrease Current Window Height"},
    ["="] = {"<C-w>+", "Increase Current Window Height"},
    [","] = {"<C-w><", "Decrease Current Window Width"},
    ["."] = {"<C-w>>", "Increase Current Window Width"},
  },

  ["<leader>b"] = {
    ["name"] = "+buffer",
    ["d"] = {":bdelete<CR>", "Delete Buffer"},
  },

  ["<Leader><Tab>"] = {"<C-^>", "Edit Alternate File"},

  ["<leader>1"] = {"1gt<CR>", "Go To Tab 1"},
  ["<leader>2"] = {"2gt<CR>", "Go To Tab 2"},
  ["<leader>3"] = {"3gt<CR>", "Go To Tab 3"},
  ["<leader>4"] = {"4gt<CR>", "Go To Tab 4"},
  ["<leader>5"] = {"5gt<CR>", "Go To Tab 5"},
  ["<leader>6"] = {"6gt<CR>", "Go To Tab 6"},
  ["<leader>7"] = {"7gt<CR>", "Go To Tab 7"},
  ["<leader>8"] = {"8gt<CR>", "Go To Tab 8"},
  ["<leader>9"] = {"9gt<CR>", "Go To Tab 9"},
  ["<leader>-"] = {"gt<CR>", "Go To Next Buffer"},
  ["<leader>="] = {"gT<CR>", "Go To Previos Buffer"},

  ["<Leader>t"] = {
    ["name"] = "+tab",
    ["c"] = {function() require("modules.ui.window").close_buffers() end, "Close Tab"}
  } ,

  ["<M-q>"] = {t'<C-\\><C-n>', "Enter Normal Mode In Terminal"},
  ["<M-m>"] = {function() require("modules.ui.window").scroll_adjacent_window("down") end, {mode = {"n","t"}}},
  ["<M-p>"] = {function() require("modules.ui.window").scroll_adjacent_window("up") end, {mode = {"n","t"}}},

  ["<M-u>"] = {function() require("modules.ui.window").scroll_quickfix("up") end, {mode = {"n","t"}}},
  ["<M-d>"] = {function() require("modules.ui.window").scroll_quickfix("down") end, {mode = {"n","t"}}},

  ["H"] = {"<C-w>h", "Move Cursor To Left Window"},
  ["L"] = {"<C-w>l", "Move Cursor To Right Window"},
  ["J"] = {"<C-w>j", "Move Cursor To Window Below"},
  ["K"] = {"<C-w>k", "Move Cursor To Window Above"},

  ["<leader>t"] = {
	["name"] ="+tree/translate",
	["t"] = {":NvimTreeToggle<CR>", "Toggle NvimTree"},
	["o"] = {":NvimTreeOpen<CR>", "Open NvimTree"},
	["c"] = {":NvimTreeClose<CR>", "Close NvimTree"},
  }
}

return M
