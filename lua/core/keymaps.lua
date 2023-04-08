local Util = require("core.util")

vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Clear search with <esc>
map(
  { "i", "n" },
  "<esc>",
  "<Cmd>noh<CR><esc>",
  { desc = "Escape and clear hlsearch" }
)

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- vim-unimpaired-like mappings adapted from vim-unimpaired
local option_pairs = {
  ["s"] = "spell",
  ["w"] = "wrap",
  ["l"] = "list",
  ["h"] = "hlsearch",
}
for key, option in pairs(option_pairs) do
  map("n", "[o" .. key, function()
    Util.enable(option)
  end, { desc = "Enable " .. option })
  map("n", "]o" .. key, function()
    Util.disable(option)
  end, { desc = "Disable " .. option })
end

map("n", "[oq", "<Cmd>copen<CR>", { desc = "Open Quickfix" })
map("n", "]oq", "<Cmd>cclose<CR>", { desc = "Close Quickfix" })
map("n", "[a", "<Cmd>previous<CR>")
map("n", "]a", "<Cmd>next<CR>")
map("n", "[A", "<Cmd>first<CR>")
map("n", "]A", "<Cmd>next<CR>")
map("n", "[b", "<Cmd>bprevious<CR>")
map("n", "]b", "<Cmd>bnext<CR>")
map("n", "[B", "<Cmd>bfirst<CR>")
map("n", "]B", "<Cmd>blast<CR>")
map("n", "[q", "<Cmd>cprevious<CR>")
map("n", "]q", "<Cmd>cnext<CR>")
map("n", "[Q", "<Cmd>cfirst<CR>")
map("n", "]Q", "<Cmd>clast<CR>")
map("n", "[l", "<Cmd>lprevious<CR>")
map("n", "]l", "<Cmd>lnext<CR>")
map("n", "[L", "<Cmd>lfirst<CR>")
map("n", "]L", "<Cmd>llast<CR>")
map("n", "[t", "<Cmd>tprevious<CR>")
map("n", "]t", "<Cmd>tnext<CR>")
map("n", "[T", "<Cmd>tfirst<CR>")
map("n", "]T", "<Cmd>tlast<CR>")

-- Line operations
function BlankUp()
  local cmd = "put!=repeat(nr2char(10), v:count1)|silent ']+"
  if vim.o.modifiable then
    cmd = cmd
      .. [[|silent! call repeat#set("\<Plug>(unimpaired-blank-up)", v:count1)]]
  end
  return cmd
end

function BlankDown()
  local cmd = "put =repeat(nr2char(10), v:count1)|silent '[-"
  if vim.o.modifiable then
    cmd = cmd
      .. [[|silent! call repeat#set("\<Plug>(unimpaired-blank-down)", v:count1)]]
  end
  return cmd
end

map("n", "<Plug>(unimpaired-blank-up)", ":<C-U>exe v:lua.BlankUp()<CR>")
map("n", "<Plug>(unimpaired-blank-down)", ":<C-U>exe v:lua.BlankDown()<CR>")
map("n", "<Plug>unimpairedBlankUp", ":<C-U>exe v:lua.BlankUp()<CR>")
map("n", "<Plug>unimpairedBlankDown", ":<C-U>exe v:lua.BlankDown()<CR>")

map(
  "n",
  "[<Space>",
  "<Plug>(unimpaired-blank-up)",
  { desc = "Add [count] blank lines above the cursor" }
)
map(
  "n",
  "]<Space>",
  "<Plug>(unimpaired-blank-down)",
  { desc = "Add [count] blank lines below the cursor" }
)

-- Keep view centered on screen
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-o>", "<C-o>zz", {})
map("n", "<C-]>", "<C-]>zz", {})

-- Distinguish <C-I> and <Tab>
map("n", "<C-I>", "<C-I>")
map("n", "<Tab>", "<Tab>")

map("n", "ZA", "<Cmd>wqa<CR>", { desc = "Quit all buffers" })

map("i", "<C-v>", "<C-r>+", { desc = "Paste text" })
map("i", "<C-z>", "<Cmd>undo<CR>", { desc = "Undo change" })
map({ "i", "v", "n", "s" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save file" })
