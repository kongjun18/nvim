local M = {}
local config = require("core.config")

---@alias CoreNotifyOpts {lang?:string, title?:string, level?:number}

---@param msg string|string[]
---@param opts? CoreNotifyOpts
function M.notify(msg, opts)
  if vim.in_fast_event() then
    return vim.schedule(function()
      M.notify(msg, opts)
    end)
  end

  opts = opts or {}
  if type(msg) == "table" then
    msg = table.concat(
      vim.tbl_filter(function(line)
        return line or false
      end, msg),
      "\n"
    )
  end
  local lang = opts.lang or "markdown"
  vim.notify(msg, opts.level or vim.log.levels.INFO, {
    on_open = function(win)
      pcall(require, "nvim-treesitter")
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].filetype = lang
        vim.bo[buf].syntax = lang
      end
    end,
    title = opts.title or "core",
  })
end

---@param msg string|string[]
---@param opts? CoreNotifyOpts
function M.error(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? CoreNotifyOpts
function M.info(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? CoreNotifyOpts
function M.warn(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

-- @param option string
-- @slient? boolean
function M.enable(option, silent)
  vim.cmd("set " .. option)
  if not silent then
    M.info("Enabled " .. option, { title = "Option" })
  end
end

-- @param option string
-- @slient? boolean
function M.disable(option, silent)
  vim.cmd("set no" .. option)
  if not silent then
    M.warn("Disabled " .. option, { title = "Option" })
  end
end

function M.in_ft_blacklist(buf)
  return vim.tbl_contains(config.ft_blacklist, vim.bo[buf].filetype)
end

function M.in_bt_blacklist(buf)
  return vim.tbl_contains(config.bt_blacklist, vim.bo[buf].buftype)
end

function M.in_blacklist(buf)
  return M.in_ft_blacklist(buf) or M.in_bt_blacklist(buf)
end

return M
