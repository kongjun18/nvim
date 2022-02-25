local M = {}
M.augroups = {
  {
    group = "matchit",
    autocmds = {
      -- Add git conflict maker to machit
      {
        event = "BufReadPre",
        pattern = "*",
        cmd = function()
          vim.b.match_words = "^<<<<<<<:^|||||||:^=======:^>>>>>>>"
        end,
      },
    },
  },
  {
    group = "format",
    autocmds = {
      {
        event = "BufWritePre",
        pattern = "*",
        cmd = function()
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
      },
    },
  },
  {
    group = "backup",
    autocmds = {
      {
        event = "BufWritePre",
        pattern = "*",
        cmd = function()
          vim.o.backupext = string.format(
            "~%s~%s",
            vim.fn.expand("%:p:h:t"),
            vim.fn.strftime("%Y-%m-%d")
          )
        end,
      },
    },
  },
}

local autocmd_lua = require("core.autocmd")
for _, augroup in pairs(M.augroups) do
  autocmd_lua.augroup(augroup)
end

return M
