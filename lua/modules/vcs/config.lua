local config = {}

function config.gitsigns()
  GlobalPacker:setup("gitsigns")
end

function config.git_conflict()
  GlobalPacker:setup("git-conflict")
end

return config
