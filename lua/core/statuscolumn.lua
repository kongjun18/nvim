local M = {}
_G.Status = M

function M.column()
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

vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

return M
