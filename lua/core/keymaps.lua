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

-- Normal editor mappings
map("i", "<C-v>", "<C-r>+", { desc = "Paste text" })
map("i", "<C-z>", "<Cmd>undo<CR>", { desc = "Undo change" })
map({ "i", "v", "n", "s" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save file" })

-- Tabline
map("n", "<Leader>1", "1gt", { desc = "Go to Tab 1" })
map("n", "<Leader>2", "2gt", { desc = "Go to Tab 2" })
map("n", "<Leader>3", "3gt", { desc = "Go to Tab 3" })
map("n", "<Leader>4", "4gt", { desc = "Go to Tab 4" })
map("n", "<Leader>5", "5gt", { desc = "Go to Tab 5" })
map("n", "<Leader>6", "6gt", { desc = "Go to Tab 6" })
map("n", "<Leader>7", "7gt", { desc = "Go to Tab 7" })
map("n", "<Leader>8", "8gt", { desc = "Go to Tab 8" })
map("n", "<Leader>9", "9gt", { desc = "Go to Tab 9" })
map("n", "<Leader>-", "gT", { desc = "Go To Previous Tab" })
map("n", "<Leader>=", "gt", { desc = "Go to Next Tab" })

map("n", "<Leader><Tab>", function()
  local in_blacklist = require("core.util").in_blacklist
  local alternate_buf = vim.fn.bufnr("#")
  if alternate_buf < 1 then
    return
  end
  if not (in_blacklist(alternate_buf) or in_blacklist(vim.fn.bufnr())) then
    return t("<C-^>")
  end
end, {
  expr = true,
  desc = "Edit Alternate File",
})

-- Better builtin keymaps
map("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, {
  desc = "Smart Insert", -- Insert At Proper Indent On Empty Line
  expr = true,
})

map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, {
  expr = true,
  desc = "Smart dd",
})

map("t", "<S-Space>", "<Space>", {desc="Workaround for Vim issue #6040"})

map("c", "%%", function()
  vim.api.nvim_feedkeys(vim.fn.expand("%:p:h") .. "/", "c", false)
end, {desc = "Input current file name in cmdline"})
map("c", "<C-j>", function ()
  vim.api.nvim_feedkeys(t"<Down>", "c", false)

end)
map("c", "<C-k>", function ()
  vim.api.nvim_feedkeys(t"<Up>", "c", false)
end)
