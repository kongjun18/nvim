local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
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
autocmd("BufEnter", {
  desc = "Automatically close some windows",
  group = "autoclose",
  nested = true,
  callback = function()
    if
      vim.fn.winnr("$") == 1
      and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr()
    then
      vim.cmd("quit")
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
    vim.cmd("silent! NightfoxCompile")
  end,
})

autocmd("BufEnter", {
  command = "syntax on",
})
