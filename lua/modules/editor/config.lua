local config = {}

config.telescope_extensions = {
  "fzy_native", -- Load native sorter for better performance
  "asynctasks",
  "projects",
}

function config.matchup()
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
  vim.g.matchup_matchpref = { cpp = { template = 1 } }
end

function config.terminal_help()
  vim.g.terminal_cwd = 0
end

function config.auto_session()
  GlobalPacker:setup("auto-session", {
    auto_session_enabled = false,
    auto_session_enable_last_session = false,
  })
end

function config.ts_autotag()
  GlobalPacker:setup("nvim-ts-autotag")
end

function config.todo_comments()
  GlobalPacker:setup("todo-comments")
end

function config.autopairs()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if not ok then
    return
  end

  local Rule = require("nvim-autopairs.rule")
  local cond = require("nvim-autopairs.conds")

  autopairs.setup({
    check_ts = true,
    enable_check_bracket_line = false,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    disable_in_macro = false,
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
    enable_moveright = true,
    enable_afterquote = true,
    map_c_w = false,
    map_bs = true,
    disable_in_visualblock = false,
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  })

  -- Map <CR>
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
  )

  autopairs.add_rules({
    Rule(" ", " "):with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ "()", "[]", "{}" }, pair)
    end),
    Rule("( ", " )")
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%)") ~= nil
      end)
      :use_key(")"),
    Rule("{ ", " }")
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%}") ~= nil
      end)
      :use_key("}"),
    Rule("[ ", " ]")
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%]") ~= nil
      end)
      :use_key("]"),
  })
  -- sh: enable ()/{} in string
  autopairs.add_rules({
    Rule("{", "}", "sh"),
    Rule("(", ")", "sh"),
  })
end

function config.treesitter()
  local ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return
  end
  -- Download packages via Git
  require("nvim-treesitter.install").prefer_git = true
  -- Download packages from mirror
  local parsers = require("nvim-treesitter.parsers").get_parser_configs()
  for _, p in pairs(parsers) do
    p.install_info.url = p.install_info.url:gsub(
      "https://github.com/",
      GlobalPacker.mirror
    )
  end

  treesitter.setup({
    auto_install = true,
    highlight = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["am"] = "@comment.outer",
          ["ii"] = "@conditional.inner",
          ["ai"] = "@conditional.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
        },
      },
      move = {
        enable = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
        },
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
    matchup = {
      enable = true,
    },
    autopairs = {
      eanble = true,
    },
  })
end

function config.gutentags()
  vim.g.gutentags_exclude_filetypes = {
    "text",
    "markdown",
    "cmake",
    "snippets",
    "dosini",
    "gitcommit",
    "git",
    "json",
    "help",
    "man",
  }
  vim.g.gutentags_project_root = {
    ".git",
    "compile_commands.json",
    ".root",
    "go.mod",
  }
  -- All ctags files suffixed with .tag'
  vim.g.gutentags_ctags_tagfile = ".tag"
  -- Only support universal-ctags
  vim.g.gutentags_ctags_extra_args = {
    "--fields=+niazS",
    "--extras=+q",
    "--c++-kinds=+px",
    "--c-kinds=+px",
    "--exclude=Debug",
    "--exclude=Release",
    "--exclude=Build",
    "--exclude=.cache",
    "--exclude=doc",
    "--output-format=e-ctags",
  }
  -- Set cache directory
  vim.g.gutentags_cache_dir = path(cache_dir, "tags")
end

function config.projectionist()
  vim.g.projectionist_heuristics = {
    ["*.c|*.h|*.cc|*.cpp|*.hpp"] = {
      ["*.c"] = { ["alternate"] = { "{}.h" } },
      ["*.cpp"] = { ["alternate"] = { "{}.hpp", "{}.h" } },
      ["*.cc"] = { ["alternate"] = { "{}.hpp", "{}.h" } },
      ["*.h"] = { ["alternate"] = { "{}.c", "{}.cpp", "{}.cc" } },
      ["*.hpp"] = { ["alternate"] = { "{}.cpp", "{}.cc" } },
    },
  }
end

function config.asynctasks()
  vim.g.asynctasks_term_pos = "tab"
  vim.g.asyncrun_open = 10
  vim.g.asyncrun_bell = 1
  vim.g.asyncrun_rootmarks = { ".git", "compile_commands.json", ".root" }
end

function config.telescope()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end

  vim.cmd([[ silent! PackerLoad telescope-fzy-native.nvim ]])
  vim.cmd([[ silent! PackerLoad telescope-asynctasks.nvim ]])
  -- Uses ivy theme
  local themes = require("telescope.themes")
  local defaults = themes.get_ivy()
  local previewers = require("telescope.previewers")
  -- Ignores files bigger than 100K
  local new_maker = function(filepath, bufnr, opts)
    opts = opts or {}
    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then
        return
      end
      if stat.size > 100000 then
        return
      else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end
    end)
  end
  defaults.buffer_previewer_maker = new_maker
  telescope.setup({
    defaults = defaults,
  })
  local extensions = require("modules.editor.config").telescope_extensions
  for _, extension in ipairs(extensions) do
    telescope.load_extension(extension)
  end
end

function config.neogen()
  GlobalPacker:setup("neogen", {
    snippet_engine = "luasnip",
    languages = {
      template = {
        annotation_convention = "ldoc",
      },
    },
  })
end

function config.project()
  GlobalPacker:setup("project_nvim")
end

-- TODO: comment and copy
-- TODO: uncomment consecutive // block
function config.nerdcommenter()
  local g = vim.g
  g.NERDSpaceDelims = 1
  g.NERDDefaultAlign = "both"
  g.NERDCommentEmptyLines = 1
  g.NERDTrimTrailingWhitespace = 1
  g.NERDToggleCheckAllLines = 1
  g.NERDAllowAnyVisualDelims = 0
  g.NERDAltDelims_asm = 1
end

function config.spellsitter()
  GlobalPacker:setup("spellsitter")
end

function config.nvim_lastplace()
  GlobalPacker:setup("nvim-lastplace")
end

function config.nvim_surround()
  GlobalPacker:setup("nvim-surround")
end

return config
