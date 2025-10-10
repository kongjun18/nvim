local M = {}
_G.Status = M

---@return {name:string, text:string, texthl:string}[]
local function get_signs()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end
local function sign_column()
  local sign
  for _, s in ipairs(get_signs()) do
    sign = s
    break
  end
  if sign then
    sign = string.format("%%#%s#%s%%*", sign.texthl, sign.text)
  else
    sign = "  "
  end

  local extsigns = vim.api.nvim_buf_get_extmarks(
    0,
    -1,
    0,
    -1,
    { details = true, type = "sign" }
  )
  local extsigns_map = {}
  for _, extmark in ipairs(extsigns) do
    extsigns_map[extmark[2] + 1] = extmark[4]
  end
  local git_sign = extsigns_map[vim.v.lnum]

  local components = {
    sign,
    [[%=]],
    [[%3{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
    (git_sign and git_sign.sign_hl_group and git_sign.sign_text)
        and ("%#" .. git_sign.sign_hl_group .. "#" .. git_sign.sign_text .. "%*")
      or "  ",
  }
  return table.concat(components, "")
end

local function extmark_column()
  local extsigns = vim.api.nvim_buf_get_extmarks(
    0,
    -1,
    0,
    -1,
    { details = true, type = "sign" }
  )
  local gitsigns = {}
  local lspsigns = {}
  for _, extmark in ipairs(extsigns) do
    -- GitSignsXXX or DiagnosticXXX
    if string.sub(extmark[4].sign_hl_group, 1, 1) == "G" then
      sign = extmark[4]
      gitsigns[extmark[2] + 1] = "%#"
        .. sign.sign_hl_group
        .. "#"
        .. sign.sign_text
        .. "%*"
    else
      sign = extmark[4]
      lspsigns[extmark[2] + 1] =
        string.format("%%#%s#%s%%*", sign.sign_hl_group, sign.sign_text)
    end
  end
  local git_sign = gitsigns[vim.v.lnum] and gitsigns[vim.v.lnum] or "  "
  local lsp_sign = lspsigns[vim.v.lnum] and lspsigns[vim.v.lnum] or "  "
  local components = {
    lsp_sign,
    [[%=]],
    [[%3{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
    git_sign,
  }
  return table.concat(components, "")
end

M.column = sign_column
if vim.version().prerelease then
  M.column = extmark_column
end

vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

return M
