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

local should_delete = function(win)
  local in_blacklist =
    require("core.util").in_blacklist(vim.api.nvim_win_get_buf(win))
  local normal_window = fn.win_gettype(win) == ""
  return (not normal_window) or in_blacklist
end

-- Open nvim-tree when arg is a directory.
vim.api.nvim_create_autocmd("VimEnter", {
  group = "autoclose",
  callback = function(data)
    if data.file == "" or vim.fn.isdirectory(data.file) ~= 1 then
      return
    end
    NvimTreeOpenedFromVimEnter = true
    require("nvim-tree.api").tree.open({ path = data.file })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = "autoclose",
  callback = function()
    BufferReaded = true
    NvimTreeOpenedFromVimEnter = false
  end,
  once = true,
})

autocmd("WinEnter", {
  desc = "Automatically close some windows",
  group = "autoclose",
  nested = true,
  callback = function()
    if NvimTreeOpenedFromVimEnter and not BufferReaded then
      return
    end
    local tabpages = fn.tabpagenr("$")
    local wins = api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(wins) do
      if not should_delete(win) then
        return
      end
    end
    if tabpages == 1 then
      -- If there is a unsaved buffer, 'quit' would
      -- cause error and make neovim deadlocked.
      local bufs = vim.api.nvim_list_bufs()
      for _, buf in ipairs(bufs) do
        if vim.api.nvim_get_option_value("modified", { buf = buf }) then
          return
        end
      end
      vim.cmd("quit")
    else
      vim.cmd("tabclose")
    end
  end,
})

augroup("numbertoggle", {})
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = "numbertoggle",
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = "numbertoggle",
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
    end
  end,
})

augroup("lsp", {})
autocmd("LspAttach", {
  desc = "Backup big LSP log file",
  group = "lsp",
  callback = function()
    local log = vim.lsp.get_log_path()
    local size = vim.fn.getfsize(log)
    local GB = 1000 * 1000 * 1000
    if size > 1 * GB then
      local log_backup = log .. vim.fn.strftime("-%Y-%m-%d")

      vim.loop.fs_rename(log, log_backup, function(err, success)
        if err then
          vim.notify("Failed to rename log file", vim.log.levels.WARN)
        end
        if success then
          vim.notify(
            string.format("Backup big LSP log file to %s", log_backup),
            vim.log.levels.INFO
          )
        end
      end)
    end
  end,
  once = true,
})

vim.cmd("autocmd DiffUpdated * call git#diff_updated_handler()")
