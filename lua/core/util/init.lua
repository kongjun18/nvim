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

-- @return integer|nil fd file descriptor
-- @return string|nil path
-- @return vim.loop.errno|nil error
function M.tempfile()
  local path = vim.fn.tempname()
  local stat = vim.loop.fs_stat(path)
  if stat then
    return nil, path, vim.loop.errno.EEXIST
  end

  local fd, err = vim.loop.fs_open(path, "w", tonumber("0644", 8))
  if not fd then
    return nil, nil, err
  end
  return fd, path, err
end

-- @return string|nil path
-- @return vim.loop.errno|nil error
function M.tempdir()
  local path = vim.fn.tempname()
  local stat = vim.loop.fs_stat(path)
  if stat then
    return nil, path, vim.loop.errno.EEXIST
  end

  local ok, err = vim.loop.fs_mkdir(path, tonumber("0775", 8))
  if not ok then
    return nil, err
  end
  return path, nil
end

-- @return number CPU frequency in Ghz
function M.cpu_frequency()
  local cpu_info = vim.loop.cpu_info()
  local freq

  for _, info in ipairs(cpu_info) do
    local freq_str = info.model:match("@%s*(%d+%.?%d*)GHz") -- 提取 GHz 后的数字部分
    if freq_str then
      freq = tonumber(freq_str) -- 转换为数字
      break
    end
  end

  return freq or 0
end

-- @return number CPU count
function M.nproc()
  local cpu_info = vim.loop.cpu_info()
  return #cpu_info
end

return M
