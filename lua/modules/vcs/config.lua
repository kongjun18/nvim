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

function config.diffview()
  require("diffview").setup({
    view = {
      default = {
        disable_diagnostics = true,
      },
      merge_tool = {
        disable_diagnostics = true,
      },
      file_history = {
        disable_diagnostics = true,
      },
    },
    hooks = {
      view_opened = function()
        vim.cmd.wincmd("l")
      end,
    },
  })
end

return config
