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

local function setup_diffview_scroll_sync(view)
  local augroup = vim.api.nvim_create_augroup("DiffviewScrollSync_" .. view.tabpage, { clear = true })
  local syncing = false
  -- Capture the tab number while the tabpage is still valid. TabClosed fires
  -- after the tab is gone, so view.tabpage would be an invalid handle there.
  local tabnr = vim.api.nvim_tabpage_get_number(view.tabpage)

  vim.api.nvim_create_autocmd("WinScrolled", {
    group = augroup,
    callback = function(ev)
      if syncing then return end
      local scrolled_win = tonumber(ev.match)
      if not scrolled_win or not vim.api.nvim_win_is_valid(scrolled_win) then return end
      -- Only act when the scrolled window is in the Diffview tabpage.
      if vim.api.nvim_win_get_tabpage(scrolled_win) ~= view.tabpage then return end
      -- Only propagate from diff-mode windows.
      if not vim.wo[scrolled_win].diff then return end

      local info = vim.fn.getwininfo(scrolled_win)[1]
      if not info then return end
      local topline = info.topline
      local leftcol = vim.api.nvim_win_call(scrolled_win, function()
        return vim.fn.winsaveview().leftcol
      end)

      syncing = true
      for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(view.tabpage)) do
        if winid ~= scrolled_win
          and vim.api.nvim_win_is_valid(winid)
          and vim.wo[winid].diff
        then
          vim.api.nvim_win_call(winid, function()
            vim.fn.winrestview({ topline = topline, leftcol = leftcol })
          end)
        end
      end
      syncing = false
    end,
  })

  -- Clean up when the Diffview tab closes.
  vim.api.nvim_create_autocmd("TabClosed", {
    group = augroup,
    callback = function(ev)
      if tonumber(ev.match) == tabnr then
        vim.api.nvim_del_augroup_by_id(augroup)
      end
    end,
  })
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
      view_opened = function(view)
        vim.cmd.wincmd("l")
        setup_diffview_scroll_sync(view)
      end,
    },
  })
end

return config
