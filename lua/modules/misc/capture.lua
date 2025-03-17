---------------------------------------
--- Capture Like Org-Mode
---------------------------------------
local function path(...)
  local path_sep = "/"
  return table.concat({ ... }, path_sep)
end

local function insert_list_to(dst, pos, src)
  -- 检查插入位置是否有效
  if pos > 0 and pos <= #dst + 1 then
    -- 遍历要插入的列表
    for i = 1, #src do
      -- 在目标列表的pos位置插入元素
      table.insert(dst, pos, src[i])
      -- 由于列表插入操作会改变列表长度，需要更新pos位置
      pos = pos + 1
    end
  else
    print("插入位置超出目标列表范围")
    return
  end
end

local function write_list_to(list, path)
  local file, err = io.open(path, "w")

  if not file then
    print("无法打开文件: " .. err)
    return
  end

  for _, line in ipairs(list) do
    file:write(line, "\n") -- \n 表示换行符
  end
  file:close()
end

-- capture tempfile serves as a lock, which must
-- be deleted after capture buffer exits.
local function refile_to(buf, capture_path, dst)
  local date = vim.fn.strftime("%Y-%m-%d %H:%M:%S")
  local matched = {}
  for v in string.gmatch(date, "([^ ]+)") do
    table.insert(matched, v)
  end
  local day, time = matched[1], matched[2]

  local lines = {}
  local lnum = 0
  local target_heading_lnum = nil
  local previous_heading_lnum = nil
  for line in io.lines(dst) do
    lnum = lnum + 1
    table.insert(lines, line)
    if not target_heading_lnum then
      local heading = "## " .. day
      if line == heading then
        target_heading_lnum = lnum
      end
    elseif not previous_heading_lnum then
      if string.match(line, "## (%d+-%d+-%d+)") then
        previous_heading_lnum = lnum
      end
    end
  end

  local buf_content_list = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  table.insert(buf_content_list, 1, time)
  if buf_content_list[#buf_content_list] ~= "\n" then
    buf_content_list[#buf_content_list + 1] = "\n"
  end

  if target_heading_lnum and previous_heading_lnum then
    insert_list_to(lines, previous_heading_lnum, buf_content_list)
  else
    table.insert(buf_content_list, 1, string.format("## %s", day))
    insert_list_to(lines, 1, buf_content_list)
  end

  os.remove(capture_path)

  local file_exists = function(file)
    local f = io.open(file, "rb")
    if f then
      f:close()
    end
    return f ~= nil
  end
  if not file_exists(dst) then
    print(string.format("%s not exists", dst))
    return
  end

  local tempfile = dst .. ".temp"
  write_list_to(lines, tempfile)
  local ok, err = os.rename(tempfile, dst)
  if not ok then
    print(string.format("failed to rename %s to %s: %s", tempfile, dst, err))
    os.remove(tempfile)
    return
  end
end

local function capture()
  -- capture tempfile serves as a lock.
  local tempfile = path(backup_dir, "capture.md")
  local stat = vim.loop.fs_stat(tempfile)
  if stat then
    print("You are editing the capture buffer in another session!")
    return
  end

  local fd = vim.loop.fs_open(tempfile, "w", tonumber("0644", 8))
  if not fd then
    print(string.format("failed to open file %s", tempfile))
    return
  end

  vim.cmd(string.format("sp %s", tempfile))
end

local dialy_path = require("core.config").dialy_path
vim.api.nvim_create_augroup("Capture", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/capture.md" },
  callback = function(ev)
    refile_to(ev.buf, ev.file, dialy_path)
  end,
})

return capture
