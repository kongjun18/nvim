----------------------------------------------------
--- Local GBrowse
----------------------------------------------------

-- Use asyncrun to get the project root directory
local function get_project_root()
  return vim.fn["asyncrun#get_root"](vim.fn.expand("%:p"))
end

-- Get the relative path of the current file with respect to the project root
local function get_relative_path()
  local project_root = get_project_root()
  local current_file = vim.fn.expand("%:p") -- Get the absolute path of the current file
  local relative_path = vim.fn.fnamemodify(current_file, ":.")
  if vim.fn.has("win32") == 1 then
    -- Handle path separators for Windows
    relative_path = vim.fn.substitute(relative_path, "/", "\\", "g")
  end
  return relative_path
end

-- Copy text to the system clipboard
local function copy_to_clipboard(text)
  -- Use `vim.fn.setreg` to copy the content to the system clipboard
  vim.fn.setreg("+", text)
  vim.fn.setreg("*", text)
  print("Copied to clipboard: " .. text)
end

-- Copy the cursor position in the format <relative_path:line_number> to the clipboard
local function browse()
  local relative_path = get_relative_path()
  local line_number = vim.fn.line(".")
  local position = string.format("%s:%d", relative_path, line_number)
  copy_to_clipboard(position)
end

return browse
