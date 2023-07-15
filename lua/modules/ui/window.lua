local M = {}
local fn = vim.fn
local cmd = vim.cmd

-- Scroll quickfix    40   │ "NullLSLoaded",without changing foucus
-- @param direction "up" or "down"
function M.scroll_quickfix(direction, _) -- direction, mode
  local quickfix = fn.getqflist({ winid = 0 }).winid
  if quickfix == 0 then
    cmd([[echomsg "There is no quickfix"]])
    return
  end
  cmd(
    string.format(
      [[call win_execute(%s, "%s", v:true)]],
      quickfix,
      (direction == "up") and "normal \\<C-U>" or "normal \\<C-D>"
    )
  )
end

-- direction hjkl
function M.close_window(direction)
  fn.win_execute(fn.win_getid(fn.winnr(direction)), "close", true)
end

-- direction hjkl
function M.hide_window(direction)
  fn.win_execute(fn.win_getid(fn.winnr(direction)), "hide", true)
end

function M.close_buffers()
  for _, bid in pairs(fn.tabpagebuflist()) do
    if vim.api.nvim_buf_is_valid(bid) then
      vim.api.nvim_buf_delete(bid, {})
    end
  end
end

function M.scroll_adjacent_window(direction)
  local left = fn.win_getid(fn.winnr("h"))
  local right = fn.win_getid(fn.winnr("l"))
  local current = fn.win_getid(fn.winnr())
  if left ~= current and current ~= right then
    cmd([[echomsg 'There are too more windows']])
    return
  elseif current == left and current == right then
    cmd([[echomsg 'There is only one window']])
    return
  elseif current ~= left then
    cmd(
      string.format(
        [[call win_execute(%s, "%s", v:true)]],
        left,
        (direction == "up") and "normal \\<C-Y>" or "normal \\<C-E>"
      )
    )
  else
    cmd(
      string.format(
        [[call win_execute(%s, "%s", v:true)]],
        right,
        (direction == "up") and "normal \\<C-Y>" or "normal \\<C-E>"
      )
    )
  end
end

return M
