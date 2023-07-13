local M = {}
_G.Status = M

---@return {name:string, text:string, texthl:string}[]
function M.get_signs()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

function M.column()
  local sign, git_sign
  for _, s in ipairs(M.get_signs()) do
    if s.name:find("GitSign") then
      git_sign = s
    else
      sign = s
    end
  end
  local texthl = ""
  local text = ""
  if sign then
    texthl = string.format("%%#%s", sign.texthl)
    text = string.format("#%s%%*", sign.text)
  end
  sign = string.format("%s%s", texthl, text)
  local components = {
    sign,
    [[%=]],
    [[%3{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
    git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*")
      or "  ",
  }
  return table.concat(components, "")
end

vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

return M
