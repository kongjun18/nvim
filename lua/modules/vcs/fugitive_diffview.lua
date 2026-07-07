local M = {}

-- Translate fugitive cursor targets into DiffviewOpen arguments for the d map.

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.WARN, { title = "Fugitive Diffview" })
end

local function line(lnum)
  return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
end

local function command_exists(name)
  return vim.fn.exists(":" .. name) == 2
end

local function load_diffview()
  if command_exists("DiffviewOpen") then
    return true
  end

  pcall(function()
    require("lazy").load({ plugins = { "diffview.nvim" } })
  end)

  if command_exists("DiffviewOpen") then
    return true
  end

  notify(":DiffviewOpen is not available", vim.log.levels.ERROR)
  return false
end

local function repo_root()
  local ok, root = pcall(vim.fn.FugitiveFind, ":/")
  if ok and root ~= "" then
    return root:gsub("/$", "")
  end

  local ok_git_dir, git_dir = pcall(vim.fn.FugitiveGitDir)
  if ok_git_dir and git_dir ~= "" then
    return vim.fn.fnamemodify(git_dir, ":h")
  end

  return ""
end

local function fnameescape(value)
  return vim.fn.fnameescape(value)
end

local function to_repo_relative(path)
  if not path or path == "" then
    return nil
  end

  if path:match("^%a[%w+.-]*://") then
    return path
  end

  local root = repo_root()
  local normalized = path:gsub("\\", "/")

  if root ~= "" then
    local normalized_root = root:gsub("\\", "/"):gsub("/$", "")
    if normalized == normalized_root then
      return nil
    end
    if normalized:sub(1, #normalized_root + 1) == normalized_root .. "/" then
      return normalized:sub(#normalized_root + 2)
    end
  end

  return normalized:gsub("^%./", "")
end

local function run_diffview(opts)
  if not load_diffview() then
    return
  end

  local args = {}
  local root = repo_root()

  if root ~= "" then
    table.insert(args, "-C" .. fnameescape(root))
  end

  if opts.rev and opts.rev ~= "" then
    table.insert(args, opts.rev)
  end

  if opts.cached then
    table.insert(args, "--cached")
  end

  if opts.path and opts.path ~= "" then
    table.insert(args, "--")
    table.insert(args, fnameescape(to_repo_relative(opts.path) or opts.path))
  end

  vim.cmd("DiffviewOpen " .. table.concat(args, " "))
end

local function commit_range(rev)
  if rev == "" or rev:match("%.%.") or rev:match("%^!") then
    return rev
  end
  return rev .. "^!"
end

local function first_unescaped_space(value)
  local escaped = false

  for index = 1, #value do
    local char = value:sub(index, index)
    if escaped then
      escaped = false
    elseif char == "\\" then
      escaped = true
    elseif char:match("%s") then
      return index
    end
  end
end

local function strip_cfile_prefix(value)
  if value:sub(1, 1) ~= "+" then
    return value
  end

  local index = first_unescaped_space(value)
  if not index then
    return value
  end

  return value:sub(index + 1)
end

local function unescape_fname(value)
  return (value:gsub("\\(.)", "%1"))
end

local function fugitive_parse(target)
  if not target:match("^fugitive://") then
    return nil
  end

  local ok, parsed = pcall(vim.fn.FugitiveParse, target)
  if not ok or type(parsed) ~= "table" then
    return nil
  end

  return parsed[1]
end

local function object_rev_path(object)
  if not object then
    return nil, nil
  end

  return object:match("^([^:]+):(.*)$")
end

local function open_object(object)
  if not object or object == "" then
    return false
  end

  if object == ":" or object == ":0" then
    run_diffview({ cached = true })
    return true
  end

  local stage, staged_path = object:match("^:([0-3]):(.*)$")
  if stage then
    run_diffview({
      cached = stage == "0",
      path = staged_path,
    })
    return true
  end

  local colon_path = object:match("^:(.+)$")
  if colon_path then
    run_diffview({ path = colon_path })
    return true
  end

  local rev, rev_path = object_rev_path(object)
  if rev then
    run_diffview({
      rev = commit_range(rev),
      path = rev_path,
    })
    return true
  end

  run_diffview({ rev = commit_range(object) })
  return true
end

local function open_blob_blame()
  -- Blob buffers need a blame lookup to mirror fugitive's line-based <CR>.
  local object = fugitive_parse(vim.api.nvim_buf_get_name(0))
  local rev, path = object_rev_path(object)

  if not rev or not path or path == "" then
    return false
  end

  local root = repo_root()
  if root == "" then
    return false
  end

  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local output = vim.fn.systemlist({
    "git",
    "-C",
    root,
    "blame",
    "-L",
    lnum .. "," .. lnum,
    "--porcelain",
    rev,
    "--",
    path,
  })

  if vim.v.shell_error ~= 0 then
    return false
  end

  local hash = output[1] and output[1]:match("^%^?([0-9a-f]+)%s")
  if not hash or hash:match("^0+$") then
    return false
  end

  run_diffview({
    rev = commit_range(hash),
    path = path,
  })
  return true
end

local function status_entry()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]

  while lnum > 1 and line(lnum):match("^[ @+%-]") do
    lnum = lnum - 1
  end

  local entry_line = line(lnum)
  local heading

  for index = lnum, 1, -1 do
    local text = line(index)
    if text == "" then
      break
    end

    heading = text:match("^(%u%l.- %(%d+%+?%))$")
    if heading then
      break
    end
  end

  local section = heading and heading:match("^(%u%l+)")
  local filename = entry_line:match("^[A-Z?] (.+)$")
  local commit = entry_line:match("^%l+%s+([0-9a-f]+)%s+") or entry_line:match("^([0-9a-f]+)%s+")

  return {
    commit = commit,
    filename = filename,
    heading = heading,
    section = section,
  }
end

local function status_relative_path(entry)
  if not entry.section or not entry.filename then
    return nil
  end

  local status = vim.b.fugitive_status
  local files = status and status.files and status.files[entry.section]
  local file = files and files[entry.filename]
  local relative = file and file.relative

  if type(relative) == "table" and relative[1] then
    return relative[1]
  end

  return entry.filename
end

local function open_status()
  local entry = status_entry()

  if entry.filename and (entry.section == "Staged" or entry.section == "Unstaged" or entry.section == "Untracked") then
    run_diffview({
      cached = entry.section == "Staged",
      path = status_relative_path(entry),
    })
    return true
  end

  if not entry.filename and (entry.section == "Staged" or entry.section == "Unstaged" or entry.section == "Untracked") then
    run_diffview({ cached = entry.section == "Staged" })
    return true
  end

  if entry.commit then
    run_diffview({ rev = commit_range(entry.commit) })
    return true
  end

  return false
end

local function open_blame()
  local hash = line(vim.api.nvim_win_get_cursor(0)[1]):match("^%^?[?*]*([0-9a-f]+)")
  if not hash or hash:match("^0+$") then
    return false
  end

  run_diffview({ rev = commit_range(hash) })
  return true
end

local function open_cfile()
  local ok, cfile

  if vim.bo.filetype == "fugitive" then
    ok, cfile = pcall(vim.fn["fugitive#PorcelainCfile"])
  else
    ok, cfile = pcall(vim.fn["fugitive#Cfile"])
  end

  if not ok or not cfile or cfile == "" then
    return false
  end

  local target = unescape_fname(strip_cfile_prefix(cfile))
  local object = fugitive_parse(target)

  if object then
    return open_object(object)
  end

  if target:match("^%x%x%x%x%x%x%x+$") then
    run_diffview({ rev = commit_range(target) })
    return true
  end

  run_diffview({ path = target })
  return true
end

function M.open()
  if vim.bo.filetype == "fugitive" and open_status() then
    return
  end

  if vim.b.fugitive_type == "blob" and open_blob_blame() then
    return
  end

  if vim.bo.filetype == "fugitiveblame" and open_blame() then
    return
  end

  if open_cfile() then
    return
  end

  notify("No fugitive target under cursor")
end

return M
