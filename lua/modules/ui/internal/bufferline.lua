local M = {}
M.buf2tab = {}
M.ft_blacklist = { "qf", "vista", "help" }
M.bt_blacklist = { "prompt", "nofile", "terminal" }

M.in_ft_blacklist = function(buf)
  return vim.tbl_contains(M.ft_blacklist, vim.bo[buf].filetype)
end

M.in_bt_blacklist = function(buf)
  return vim.tbl_contains(M.bt_blacklist, vim.bo[buf].buftype)
end

M.in_blacklist = function(buf)
  return M.in_ft_blacklist(buf) or M.in_bt_blacklist(buf)
end

M.in_tab = function(buf)
  local buf2tab = M.buf2tab
  return not buf2tab[buf] -- new buffer
    or vim.tbl_contains(buf2tab[buf], vim.api.nvim_get_current_tabpage())
end

-- Closes the buffer
M.close_buf = function(buf, tab)
  local buf2tab = M.buf2tab
  -- Moves to the previous buffer if `buf` is the current buffer.
  -- Notice! BufferLineGoToBuffer changes the current buffer.
  if vim.api.nvim_get_current_buf() == buf then
    vim.cmd("BufferLineCyclePrev")
  end
  if #buf2tab[buf] == 1 then -- If this buffer only used in one tab, deletes it.
    vim.api.nvim_buf_delete(buf, { force = true })
    require("bufferline.ui").refresh()
  else
    -- Closes the windows of the buffer in the current tabpage. This is to
    -- handle split screen situations. If the buffer in the last buffer in the
    -- tab, close the tab automatically by vim.
    for _, w in ipairs(vim.fn.win_findbuf(buf)) do
      if
        vim.api.nvim_win_get_tabpage(w) == tab
        and vim.api.nvim_win_get_buf(w) == buf
      then
        vim.fn.win_execute(w, "quit", "silent")
      end
    end
  end
end

M.remove_buf = function(buf, tab)
  -- The buffer is modified?
  if vim.api.nvim_buf_get_option(buf, "modified") then
    vim.notify("This buffer is modified!", vim.log.levels.WARN)
    return
  end

  local buf2tab = M.buf2tab
  for i, t in ipairs(buf2tab[buf]) do
    if t == tab then
      M.close_buf(buf, tab)
      table.remove(buf2tab[buf], i)
      break
    end
  end

  -- Quits the default [No Name] buffer.
  local tabs = vim.api.nvim_list_tabpages()
  local bufs = M.get_current_tabpage_buffers()
  if #tabs == 1 then
    if #bufs == 1 then
      if M.is_no_name_buf(bufs[1]) then
        vim.cmd("quit")
      end
    else
      for _, b in ipairs(bufs) do
        if not (M.in_blacklist(b) or M.is_no_name_buf(b)) then
          return
        end
      end
      vim.cmd("tabclose")
    end
  end
end

M.get_current_tabpage_windows = function()
  return vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
end

M.get_current_tabpage_buffers = function()
  return M.get_tabpage_buffers(vim.api.nvim_get_current_tabpage())
end

M.get_tabpage_buffers = function(tabpage)
  local bufs = {}
  local wins = vim.api.nvim_tabpage_list_wins(tabpage)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if not vim.tbl_contains(bufs, buf) then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

-- Whether the buffer is [No Name]
M.is_no_name_buf = function(buf)
  return vim.api.nvim_buf_get_option(buf, "ft") == ""
    and vim.api.nvim_buf_get_option(buf, "bt") == ""
    and vim.api.nvim_buf_get_option(buf, "modified") == false
end

M.remove_nonexisted_entries = function()
  for buf, _ in pairs(M.buf2tab) do
    if not vim.fn.bufexists(buf) then
      M.buf2tab[buf] = nil
    end
  end
end

return M
