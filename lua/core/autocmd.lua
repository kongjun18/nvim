local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn
local api = vim.api

augroup("machit", {})
autocmd("BufReadPre", {
  desc = "Add machit git conflict marker",
  group = "machit",
  callback = function()
    vim.b.match_words = "^<<<<<<<:^|||||||:^=======:^>>>>>>>"
  end,
})

augroup("format", {})
autocmd("BufWritePre", {
  desc = "Format Go code on save",
  group = "format",
  pattern = "*.go",
  callback = function()
    local ok, format = pcall(require, "go.format")
    if ok then
      format.goimport()
    end
  end,
})

autocmd("BufWritePre", {
  desc = "Remove trailing space",
  group = "format",
  callback = function()
    local filetype = vim.bo.filetype
    if
      vim.bo.modified
      and filetype ~= "gitcommit"
      and filetype ~= "NeogitCommitMessage"
    then
      local cursor = vim.fn.getcurpos()
      vim.cmd([[:keepmarks %s/\s\+$//ge]])
      vim.fn.setpos(".", cursor)
    end
  end,
})

augroup("backup", {})
autocmd("BufWritePre", {
  desc = "Set backup file suffix",
  group = "backup",
  callback = function()
    local floor = function(minute)
      if minute >= 40 then
        minute = 40
      else
        if minute >= 20 then
          minute = 20
        else
          minute = 00
        end
      end
      return minute
    end
    local strftime = vim.fn.strftime
    local expand = vim.fn.expand
    local minute = floor(tonumber(strftime("%M")))
    -- backupext: ~~<directory>~~<date>
    vim.o.backupext = string.format(
      "~%s~~%s-%s",
      string.gsub(expand("%:p:h"), path_sep, "~"),
      strftime("%Y-%m-%d-%H"),
      minute
    )
  end,
})

augroup("autoclose", {})
autocmd("WinEnter", {
  desc = "Automatically close some windows",
  group = "autoclose",
  nested = true,
  callback = function()
    local is_nvimtree = function(win)
      return fn.bufname(fn.winbufnr(win)) == "NvimTree_" .. fn.tabpagenr()
    end
    local is_vista = function(win)
      return api.nvim_buf_get_option(fn.winbufnr(win), "ft") == "vista_kind"
    end
    local is_quickfix = function(win)
      return api.nvim_buf_get_option(fn.winbufnr(win), "ft") == "qf"
    end
    local should_delete = function(win)
      return is_nvimtree(win) or is_vista(win)
    end

    local tabpages = fn.tabpagenr("$")
    local wins = api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(wins) do
      if not should_delete(win) then
        return
      end
    end
    if tabpages == 1 then
      vim.cmd("quit")
    else
      vim.cmd("tabclose")
    end
  end,
})

augroup("packer_complete", {})
autocmd("User PackerComplete", {
  desc = "Compile plugins and clear bootstrap flag",
  group = "packer_complete",
  once = true,
  callback = function()
    GlobalPacker.bootstrap = nil
  end,
})

augroup("bufferline", {})
autocmd("BufEnter", {
  desc = "Inserts the buffer into the buf2tab dict",
  group = "bufferline",
  callback = function()
    local buf2tab = require("modules.ui.internal.bufferline").buf2tab
    local buf = vim.api.nvim_get_current_buf()
    local tab = vim.api.nvim_get_current_tabpage()
    if not buf2tab[buf] then
      buf2tab[buf] = {}
    end
    for _, t in ipairs(buf2tab[buf]) do
      if t == tab then
        goto exit
      end
    end
    table.insert(buf2tab[buf], tab)
    ::exit::
  end,
})

-- TODO: remove the buffer if it only associates with the closed window.
autocmd("WinClosed", {
  callback = function()
    local buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  end,
})

vim.cmd("autocmd DiffUpdated * call git#diff_updated_handler()")
