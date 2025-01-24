local config = {}

function config.gitsigns()
  local c = {}
  if require("modules.config").yadm_enable then
    c._on_attach_pre = function(buffer, callback)
      -- Disable gitsigns-yadm.nvim for git* buffer.
      -- See https://github.com/purarue/gitsigns-yadm.nvim/issues/7.
      local ft = vim.bo[buffer].filetype
      if string.match(ft, "git%w+") then
        return callback()
      end
      require("gitsigns-yadm").yadm_signs(callback)
    end
  end
  require("gitsigns").setup(c)
end

function config.git_conflict()
  require("git-conflict").setup()
end

return config
