local config = {}

function config.gitsigns()
  require("gitsigns").setup({
    _on_attach_pre = function(_, callback)
      require("gitsigns-yadm").yadm_signs(callback)
    end,
  })
end

function config.git_conflict()
  require("git-conflict").setup()
end

return config
