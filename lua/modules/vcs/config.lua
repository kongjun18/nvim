local config = {}

function config.gitsigns()
  require("gitsigns").setup({
    yadm = {
      enable = yadm_enable,
    },
  })
end

function config.git_conflict()
  require("git-conflict").setup()
end

return config
