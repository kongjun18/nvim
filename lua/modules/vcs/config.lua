local config = {}

function config.gitsigns()
  require("gitsigns").setup({
    yadm = {
      enable = true,
    },
  })
end

function config.git_conflict()
  require("git-conflict").setup()
end

function config.gv()
  -- Open diffview
  vim.cmd([[nmap d .<C-u>DiffviewCommit<CR>]])
  vim.cmd([[command! -nargs=1 DiffviewCommit DiffviewOpen <args>~1..<args>]])
end

return config
