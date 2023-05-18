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

return config
