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

local function patch_diffview_detach_buffer()
  local ok, file_module = pcall(require, "diffview.vcs.file")
  if not ok then
    return
  end

  local File = file_module.File
  if not File or File._diffview_detach_buffer_patch then
    return
  end

  local detach_buffer = File.detach_buffer
  File.detach_buffer = function(self)
    -- Diffview can run TabClosed cleanup after diff buffers are already wiped.
    if self.bufnr and not vim.api.nvim_buf_is_valid(self.bufnr) then
      File.attached[self.bufnr] = nil
      return
    end

    local detach_ok, err = pcall(detach_buffer, self)
    if not detach_ok then
      if self.bufnr and tostring(err):match("Invalid buffer id") then
        File.attached[self.bufnr] = nil
        return
      end
      error(err)
    end
  end

  File._diffview_detach_buffer_patch = true
end

function config.diffview()
  patch_diffview_detach_buffer()

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
