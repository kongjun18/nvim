--- Capture Like Org-Mode
---------------------------------------
local ENCRYPTED_PREFIX = "# <<<encrypted>>>"

local function writefile(lines, fname)
  local success, err = pcall(function()
    vim.fn.writefile(lines, fname)
  end)

  if not success then
    vim.notify(
      string.format("Failed to write file: %s", err),
      vim.log.levels.ERROR
    )
    return false
  end

  return true
end

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then
    f:close()
  end
  return f ~= nil
end

local function insert_list_to(dst, pos, src)
  if pos > 0 and pos <= #dst + 1 then
    for i = 1, #src do
      table.insert(dst, pos, src[i])
      pos = pos + 1
    end
  end
end

local function encrypt_lines(lines, password)
  local output = vim.fn.systemlist(
    string.format(
      "openssl enc -aes-256-cbc -pbkdf2 -salt -in - -out - -k %s | base64",
      vim.fn.shellescape(password)
    ),
    lines
  )
  return output, vim.v.shell_error == 0
end

local function decrypt_lines(lines, password)
  local output = vim.fn.systemlist(
    string.format(
      "base64 --decode | openssl enc -d -aes-256-cbc -pbkdf2 -salt -in - -out - -k %s",
      vim.fn.shellescape(password)
    ),
    lines
  )
  return output, vim.v.shell_error == 0
end

local function refile_to(buf, dst)
  local date = vim.fn.strftime("%Y-%m-%d %H:%M:%S")
  local matched = {}
  for v in string.gmatch(date, "([^ ]+)") do
    table.insert(matched, v)
  end
  local day, time = matched[1], matched[2]

  local password = vim.fn.inputsecret("Enter password: ")
  if password == "" then
    return
  end

  local lines = {}
  for line in io.lines(dst) do
    table.insert(lines, line)
  end
  if #lines == 0 then
    lines = {}
  else
    if lines[1] ~= ENCRYPTED_PREFIX then
      vim.notify(
        "Invalid file format: the diary file is not encrypted.",
        vim.log.levels.ERROR
      )
      return
    end
    table.remove(lines, 1)
    lines, ok = decrypt_lines(lines, password)
    if not ok then
      vim.notify("Failed to decrypt the diary.", vim.log.levels.ERROR)
      return
    end
  end

  local target_heading_lnum = nil
  local previous_heading_lnum = nil
  for lnum, line in ipairs(lines) do
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
    buf_content_list[#buf_content_list + 1] = ""
  end

  if target_heading_lnum and previous_heading_lnum then
    insert_list_to(lines, previous_heading_lnum, buf_content_list)
  else
    table.insert(buf_content_list, 1, string.format("## %s", day))
    insert_list_to(lines, 1, buf_content_list)
  end

  local encrypted_lines, ok = encrypt_lines(lines, password)
  if not ok then
    vim.notify("Failed to encrypt the diary.", vim.log.levels.ERROR)
    return
  end
  table.insert(encrypted_lines, 1, ENCRYPTED_PREFIX)
  if writefile(encrypted_lines, dst) then
    vim.api.nvim_set_option_value("modified", false, { buf = buf })
  end
end

local function capture()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.cmd("sp")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Capture")
  vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("undofile", false, { buf = buf })
  vim.api.nvim_create_autocmd({ "BufWriteCmd" }, {
    buffer = buf,
    callback = function()
      local diary_path = require("core.config").diary_path
      if not file_exists(diary_path) then
        vim.notify(
          string.format("Diary %s not exists", diary_path),
          vim.log.levels.ERROR
        )
        return
      end

      refile_to(buf, diary_path)
    end,
  })
end

return capture
