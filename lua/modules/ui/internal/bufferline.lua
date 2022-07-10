local M = {}
M.buf2tab = {}
M.ft_blacklist = { "qf", "vista_kind" }
M.bt_blacklist = {}

M.in_blacklist = function(buf)
  local bt_blacklist =
    require("modules.ui.internal.bufferline").bt_blacklist
  local ft_blacklist =
    require("modules.ui.internal.bufferline").ft_blacklist
  return vim.tbl_contains(ft_blacklist, vim.api.nvim_buf_get_option(buf, "ft"))
    or vim.tbl_contains(bt_blacklist, vim.api.nvim_buf_get_option(buf, "bt"))
end

M.in_tab = function(buf)
  local buf2tab = require("modules.ui.internal.bufferline").buf2tab
  return not buf2tab[buf] -- new buffer
    or vim.tbl_contains(buf2tab[buf], vim.api.nvim_get_current_tabpage())
end

M.remove_buf = function(buf, tab)
  local bufferline = require("modules.ui.internal.bufferline")
  local buf2tab = bufferline.buf2tab
  for i, t in ipairs(buf2tab[buf]) do
    if t == tab then
      table.remove(buf2tab[buf], i)
      if #buf2tab[buf] == 0 then
        -- Moves to the previous buffer if `buf` is the current buffer.
        -- And then, deletes it.
        if vim.api.nvim_get_current_buf() == buf then
          vim.cmd("BufferLineCyclePrev")
        end
        vim.api.nvim_buf_delete(buf, { force = true })
      else
        local bufs = bufferline.get_current_tabpage_buffers()
        -- quits vim or tabpage depending on whether the buffer is the last active buffer.
        if #bufs == 1 and bufs[1] == buf then
          return (#vim.api.nvim_list_tabpages() == 1) and vim.cmd("quit")
            or vim.cmd("tabclose")
        end
      end
      break
    end
  end
  local tabs = vim.api.nvim_list_tabpages()
  local bufs = bufferline.get_current_tabpage_buffers()
  if #tabs == 1 and #bufs == 1 then
    if
      vim.api.nvim_buf_get_option(bufs[1], "ft") == ""
      and vim.api.nvim_buf_get_option(bufs[1], "bt") == ""
    then
      vim.cmd("quit")
    end
  end
end

M.get_current_tabpage_windows = function()
  return vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
end

M.get_current_tabpage_buffers = function()
  local bufs = {}
  local wins = M.get_current_tabpage_windows()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if not vim.tbl_contains(bufs, buf) then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

return M
