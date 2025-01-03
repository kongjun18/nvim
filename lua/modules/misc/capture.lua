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

  -- 检查文件是否成功打开
  if not file then
    print("无法打开文件: " .. err)
    return
  end

  -- 遍历列表，并将每个元素写入文件
  for _, line in ipairs(list) do
    -- 写入一行到文件
    file:write(line, "\n") -- \n 表示换行符
  end
  -- 关闭文件
  file:close()
end

-- TODO: lock file
local function refile_to(src, dst, buf)
  local basename = vim.fs.basename(src)
  local date = string.match(basename, "(.*).md")
  local matched = {}
  for v in string.gmatch(date, "([^ ]+)") do
    table.insert(matched, v)
  end
  local day, time = matched[1], matched[2]
  -- 打开文件用于读取
  local file_exists = function(file)
    local f = io.open(file, "rb")
    if f then
      f:close()
    end
    return f ~= nil
  end
  if not file_exists(dst) then
    print("无法打开文件")
    return
  end

  -- 按行读取文件
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
  local tempfile = dst .. ".temp"
  write_list_to(lines, tempfile)
  os.rename(tempfile, dst)
end

local function capture()
  local dir = path(vim.fn.stdpath("cache"), "capture")
  local stat = vim.loop.fs_stat(dir)
  if not stat then
    -- 目录不存在，创建目录
    local result = vim.loop.fs_mkdir(dir, tonumber("0775", 8))
    if not result then
      print("Failed to create directory: " .. dir)
      return
    end
  end

  local date = vim.fn.strftime("%Y-%m-%d %H:%M:%S")
  local tempfile = path(dir, string.format("%s.md", date))
  local fd = vim.loop.fs_open(tempfile, "w", tonumber("0644", 8))
  if not fd then
    print(string.format("failed to open file %s", tempfile))
    return
  end

  -- TODO: temp file
  vim.cmd(string.format("sp %s", tempfile))
end

local dialy_path = require("core.config").dialy_path
vim.api.nvim_create_augroup("Capture", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/capture/*.md" },
  callback = function(ev)
    refile_to(ev.file, dialy_path, ev.buf)
  end,
})

vim.api.nvim_create_user_command("Capture", capture, {})
