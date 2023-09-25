-- vim: ft=lua tw=80
std = "lua51+nvim"

-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
  "631", -- max_line_length
  "212/_.*", -- unused argument, for vars with "_" prefix
  "214", -- used variable with unused hint ("_" prefix)
  "121", -- setting read-only global variable 'vim'
  "122", -- setting read-only field of global variable 'vim'
  "581", -- negation of a relational operator- operator can be flipped (not for tables)
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}

globals = {
  "vim",
  "vim.g",
  "vim.b",
  "vim.w",
  "vim.o",
  "vim.bo",
  "vim.wo",
  "vim.go",
  "vim.env",

  -- Global variables in ,config
  "NullLSLoaded",
  "DictionaryLoaded",
  "ctags_extra_args",
  "bqf_pv_timer",
  "NvimTreeOpenedFromVimEnter",
  "BufferReaded",

  "os_name",
  "is_linux",
  "is_windows",
  "config_dir",
  "cache_dir",
  "data_dir",
  "home",
  "path_sep",
  "modules_dir",
  "core_dir",
  "lazy_dir",
  "backup_dir",
  "swap_dir",
  "undo_dir",
  "session_dir",
  "dict_dir",
  -- Global functions
  "t",
  "path",
  "BlankUp",
  "BlankDown",
  "codeium_enable",
  "wakatime_enable",
  "yadm_enable",
}
