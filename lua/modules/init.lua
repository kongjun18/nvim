-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load modules
local modules = { "ui", "editor", "lsp", "vcs", "dap" }

local keymaps = {}
local specs = {}
for _, module in pairs(modules) do
  local m = require("modules/" .. module)
  for repo, conf in pairs(m.plugins) do
    local spec = vim.tbl_extend("force", { repo }, conf)
    table.insert(specs, spec)
  end
  if m.keymaps then
    for _, keymap in ipairs(m.keymaps) do
      table.insert(keymaps, keymap)
    end
  end
end

require("lazy").setup(specs, {
  install = {
    colorscheme = { "nightfox" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tar",
        "tarPlugin",
        "zip",
        "zipPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "logiPat",
        "matchit",
        "matchparen",
        "rrhelper",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "rplugin",
        "spellfile",
        "tohtml",
        "tutor.vim",
      },
    },
  },
})
require("which-key").add(keymaps)
