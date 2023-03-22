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

-- Save file
map({ "i", "v", "n", "s" }, "<C-s>", "<Cmd>w<CR><esc>", { desc = "Save file" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- vim-unimpaired-like mappings adapted from vim-unimpaired
map("n", "[os", function()
  Util.enable("spell")
end, { desc = "Enable Spelling" })
map("n", "]os", function()
  Util.disable("spell")
end, { desc = "Disable Spelling" })
map("n", "[ow", function()
  Util.enable("wrap")
end, { desc = "Enable Line Wrap" })
map("n", "]ow", function()
  Util.disable("wrap")
end, { desc = "Disable Line Wrap" })
map("n", "[ol", function()
  Util.enable("list")
end, { desc = "Enable List" })
map("n", "]ol", function()
  Util.disable("list")
end, { desc = "Disable List" })
map("n", "[op", function()
  Util.enable("paste")
end, { desc = "Enable Paste" })
map("n", "]op", function()
  Util.disable("paste")
end, { desc = "Disable Paste" })
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
map("n", "<Plug>(unimpaired-blank-up)", function()
  local cmd = "put!=repeat(nr2char(10), v:count1)|silent '']+"
  if vim.o.modified then
    cmd = cmd
      .. [[|silent! call repeat#set("<Plug>(unimpaired-blank-up)", v:count1)]]
  end
  return cmd
end, { expr = true })
map("n", "<Plug>(unimpaired-blank-down)", function()
  local cmd = "put =repeat(nr2char(10), v:count1)|silent ''[-"
  if vim.o.modifiable then
    cmd = cmd
      .. [[|silent! call repeat#set("<Plug>(unimpaired-blank-down)", v:count1)]]
  end
  return cmd
end, { expr = true })
map("n", "[<Space>", "<Plug>(unimpaired-blank-up)")
map("n", "]<Space>", "<Plug>(unimpaired-blank-down)")

map("n", "ZA", "<Cmd>wqa<CR>", { desc = "Quit all buffers" })

map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-o>", "<C-o>zz", {})
map("n", "<C-]>", "<C-]>zz", {})
map("n", "<C-I>", "<C-I>")
map("n", "<Tab>", "<Tab>")
