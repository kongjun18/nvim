-- TODO: move to modules/editor/keymap.lua
--
module("core.keymaps", package.seeall)

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function nmap(lhs, rhs, opts)
  opts = opts or {}
  map("n", lhs, rhs, opts)
end

function vmap(lhs, rhs, opts)
  opts = opts or {}
  map("v", lhs, rhs, opts)
end

function imap(lhs, rhs, opts)
  opts = opts or {}
  map("i", lhs, rhs, opts)
end

function xmap(lhs, rhs, opts)
  opts = opts or {}
  map("x", lhs, rhs, opts)
end

function tmap(lhs, rhs, opts)
  opts = opts or {}
  map("t", lhs, rhs, opts)
end

vim.g.mapleader = " "

local function map_jump()
  nmap("j", "gj")
  nmap("k", "gk")
  nmap("ZA", ":wqa<CR>")
  nmap("<C-d>", "<C-d>zz")
  nmap("<C-u>", "<C-u>zz")
  nmap("<C-o>", "<C-o>zz")
  nmap("<C-]>", "<C-]>zz")
  nmap("``", "``zz")
  nmap("n", "nzz")
  nmap("N", "Nzz")
end

local function map_registers()
  nmap("'+", '"+')
  vmap("'+", '"+')
  nmap("'=", '"=')
  vmap("'=", '"=')
  vmap("'0", '"0')
  vmap("'0", '"0')
  imap("<C-R>'", '<C-R>"')
  xmap("q", '"')
end

local function map_unimpaired()
  nmap("]oq", ":cclose<CR>")
  nmap("[oq", ":copen<CR>")

  nmap("[op", ":setlocal paste<CR>")
  nmap("]op", ":setlocal nopaste<CR>")
  nmap("yop", ":setlocal paste!<CR>")
end

map_jump()
map_registers()
map_unimpaired()
vim.keymap.set("n", "<2-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<RightMouse>", "<C-O>")
vim.keymap.set("n", "<2-RightMouse>", "<C-O><C-O>")
vim.keymap.set("n", "<M-RightMouse>", "<C-I>")
