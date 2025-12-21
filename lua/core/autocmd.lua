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

local function floor_minute(minute)
  if minute >= 40 then
    return 40
  elseif minute >= 20 then
    return 20
  else
    return 0
  end
end

local function backup_ext()
  local strftime = vim.fn.strftime
  local expand = vim.fn.expand
  local minute = floor_minute(tonumber(strftime("%M")))
  local bufname = expand("%:p")

  if bufname == "" then
    return unnamed_backup_ext()
  end

  -- backupext: ~~<directory>~~<date>
  return string.format(
    "~%s~~%s-%s",
    string.gsub(expand("%:p:h"), path_sep, "~"),
    strftime("%Y-%m-%d-%H"),
    minute
  )
end

local function get_unnamed_backup_ext()
  local strftime = vim.fn.strftime
  local minute = floor_minute(tonumber(strftime("%M")))
  local cwd = vim.fn.getcwd()
  return string.format(
    "unnamed~~%s~~%s-%s",
    string.gsub(cwd, path_sep, "~"),
    strftime("%Y-%m-%d-%H"),
    minute
  )
end

autocmd("BufWritePre", {
  desc = "Set backup file suffix",
  group = "backup",
  callback = function()
    vim.o.backupext = backup_ext()
  end
})


local last_tick = {}

local function backup_unnamed_buffer(buf, skip_modified_check)
  if skip_modified_check == nil then
    skip_modified_check = false
  end

  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
  if buftype ~= "" then
    return
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" then
    return
  end

  local backup_dir = vim.fn.stdpath("data") .. "/backup"
  vim.fn.mkdir(backup_dir, "p")

  -- Only back up modified buffers unless explicitly requested (close/exit)
  if not skip_modified_check and not vim.api.nvim_get_option_value("modified", { buf = buf }) then
    return
  end

  -- Avoid rewriting unchanged content during periodic runs
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  if not skip_modified_check and last_tick[buf] == tick then
    return
  end
  last_tick[buf] = tick

  -- backupext: unnamed~~<directory>~~<date>
  local backup_name = string.format("%s/%s", backup_dir, get_unnamed_backup_ext())

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content = table.concat(lines, "\n")
  local file = io.open(backup_name, "w")
  if file then
    file:write(content)
    file:close()
  end
end

-- On buffer wipe/close, ensure unnamed buffer is saved once
autocmd("BufWipeout", {
  group = "backup",
  callback = function(event)
    backup_unnamed_buffer(event.buf, true)
    last_tick[event.buf] = nil
  end,
})

-- Stop timer and back up unnamed buffers when exiting
autocmd("VimLeavePre", {
  group = "backup",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      backup_unnamed_buffer(buf, true)
    end
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
