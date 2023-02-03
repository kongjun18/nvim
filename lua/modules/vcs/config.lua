local config = {}

function config.gitsigns()
  GlobalPacker:setup("gitsigns", {
    yadm = {
      enable = true,
    },
  })
end

function config.git_conflict()
  GlobalPacker:setup("git-conflict")
end

return config
