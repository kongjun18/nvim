local config = {}

function config.gitsigns()
  local c = {}
  if require("modules.config").yadm_enable then
    c._on_attach_pre = function(_, callback)
      require("gitsigns-yadm").yadm_signs(callback)
    end
  end
  require("gitsigns").setup(c)
end

function config.git_conflict()
  require("git-conflict").setup()
end

return config
