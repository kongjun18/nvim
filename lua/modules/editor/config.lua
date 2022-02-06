local config = {}

config.telescope_extensions = {
  "fzy_native",   -- Load native sorter for better performance
  "asynctasks",
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
  require("core.packer"):setup("auto-session", {
    auto_session_enabled = false,
    auto_session_enable_last_session = false,
  })
end

function config.ts_autotag()
  require("core.packer"):setup("nvim-ts-autotag")
end

function config.editorconfig()
  vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
end

function config.todo_comments()
  require("core.packer"):setup("todo-comments")
end

-- Note: copy from LunarVim
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
  cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

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

  autopairs.add_rule(Rule("$$", "$$", "tex"))
  autopairs.add_rules({
    Rule("$", "$", { "tex", "latex" }) -- don't add a pair if the next character is %
      :with_pair(cond.not_after_regex_check("%%")) -- don't add a pair if  the previous character is xxx
      :with_pair(cond.not_before_regex_check("xxx", 3)) -- don't move right when repeat character
      :with_move(cond.none()) -- don't delete if the next character is xx
      :with_del(cond.not_after_regex_check("xx")) -- disable  add newline when press <cr>
      :with_cr(cond.none()),
  })

  autopairs.add_rules({
    Rule("$$", "$$", "tex"):with_pair(function(opts)
      print(vim.inspect(opts))
      if opts.line == "aa $$" then
        -- don't add pair on that line
        return false
      end
    end),
  })

  local ts_conds = require("nvim-autopairs.ts-conds")
  -- press % => %% is only inside comment or string
  autopairs.add_rules({
    Rule("%", "%", "lua"):with_pair(
      ts_conds.is_ts_node({ "string", "comment" })
    ),
    Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
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
    local mirror = string.match(require("core.packer").mirror, "https?://(.*)")
    p.install_info.url = p.install_info.url:gsub("github.com", mirror)
  end

  treesitter.setup({
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
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })
end

-- TODO: comment and copy
-- TODO: uncomment consecutive // block
function config.comment()
  local ok, comment = pcall(require, "Comment")
  if not ok then
    return
  end

  local U = require("Comment.utils")

  local pre_hook = function(ctx)
    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location =
        require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring({
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    })
  end

  comment.setup({
    pre_hook = pre_hook,
  })
end

-- TODO: Use ctags/gtags index code when LSP is disabled
function config.gutentags()
  vim.g.load_gutentags_config = 1
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
  -- Use pygment to extend gtags
  vim.env.GTAGSLABEL = "native-pygments"
  vim.g.gutentags_project_root = { ".git", "compile_commands.json", ".root" }
  -- All ctags files suffixed with .tag'
  vim.g.gutentags_ctags_tagfile = ".tag"
  -- Use ctags and gtags
  local gutentags_modules = {}
  if vim.fn.executable("ctags") > 0 then
    table.insert(gutentags_modules, "ctags")
  end
  -- Fail to modify VimL global list. Create Lua variable and then convert to VimL.
  vim.g.gutentags_modules = gutentags_modules
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
  vim.g.gutentags_cache_dir = cache_dir .. path_sep .. "tags"
  -- Don't load gtags_cscope database automatically
  vim.g.gutentags_auto_add_gtags_cscope = 0
  vim.g.gutentags_plus_switch = 0
  vim.g.gutentags_plus_nomap = 1
end

function config.projectionist()
  vim.g.projectionist_heuristics = {
    ["*.c|*.h|*.cpp|*.hpp"] = {
      ["*.c"] = { ["alternate"] = { "{}.h" } },
      ["*.cpp"] = { ["alternate"] = { "{}.hpp", "{}.h" } },
      ["*.h"] = { ["alternate"] = { "{}.c", "{}.cpp" } },
      ["*.hpp"] = { ["alternate"] = "{}.cpp" },
    },
  }
end

function config.asynctasks()
  vim.g.asynctasks_term_pos = "tab"
  vim.g.asyncrun_open = 10
  vim.g.asyncrun_bell = 1
  vim.g.asyncrun_rootmarks = { ".git", "compile_commands.json", ".root" }
end

-- TODO: remap to LeaderF keymaps
function config.telescope()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end

  local themes = require("telescope.themes")
  telescope.setup({
    defaults = themes.get_ivy(),
  })
  local extensions = require("modules.editor.config").telescope_extensions
  for _, extension in ipairs(extensions) do
    telescope.load_extension(extension)
  end
end

function config.neogen()
  require("core.packer"):setup("neogen", {
    languages = {
      template = {
        annotation_convention = "ldoc",
      },
    },
  })
end

return config
