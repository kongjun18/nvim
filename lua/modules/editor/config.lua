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
  vim.g.matchup_surround_enabled = 1
  vim.g.matchup_matchparen_enabled = 1
end

function config.terminal_help()
  vim.g.terminal_cwd = 0
end

function config.auto_session()
  require("auto-session").setup({
    auto_session_enabled = false,
    auto_session_enable_last_session = false,
  })
end

function config.ts_autotag()
  require("nvim-ts-autotag").setup()
end

function config.todo_comments()
  require("todo-comments").setup({
    -- KEYWORD: or KEYWORD(author):
    highlight = {
      pattern = [[.*<(KEYWORDS)(\(\p+\))?\s*:]], -- vim regex
    },
    search = {
      pattern = [[\b(KEYWORDS)(\(\w+\))?\s*:]], -- ripgrep regex
    },
    -- Add keyword QUESTION
    keywords = {
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "QUESTION" } },
    },
  })
end

function config.autopairs()
  local autopairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")
  local cond = require("nvim-autopairs.conds")

  autopairs.setup({
    check_ts = true,
    enable_check_bracket_line = true,
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  })

  -- Add spaces between parentheses
  -- "%%" is used in htmldjango
  local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "%", "%" } }
  autopairs.add_rules({
    Rule(" ", " "):with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2],
        brackets[4][1] .. brackets[4][2],
      }, pair)
    end),
  })
  for _, bracket in pairs(brackets) do
    autopairs.add_rules({
      Rule(bracket[1] .. " ", " " .. bracket[2])
        :with_pair(function()
          return false
        end)
        :with_move(function(opts)
          return opts.prev_char:match(".%" .. bracket[2]) ~= nil
        end)
        :use_key(bracket[2]),
    })
  end

  -- Before    Input    After
  --   {|}       %      {%|%}
  --   {%|%}   <space>  {% | %}
  autopairs.add_rules({
    Rule("%", "%", "htmldjango"):with_pair(cond.before_text("{")),
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
  -- local parsers = require("nvim-treesitter.parsers").get_parser_configs()
  -- for _, p in pairs(parsers) do
  -- p.install_info.url = p.install_info.url:gsub(
  -- "https://github.com/",
  -- GlobalPacker.mirror
  -- )
  -- end

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
          ["im"] = "@comment.inner",
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
    matchup = {
      enable = true,
    },
    autopairs = {
      eanble = true,
    },
  })
end

function config.gutentags()
  -- Set cache directory.
  -- Fix issue [#28](https://github.com/kongjun18/nvim/issues/28)
  local tags_dir = path(cache_dir, "tags")
  if not vim.loop.fs_stat(tags_dir) then
    -- 493 is 0755 in decimal
    ---@diagnostic disable-next-line: unused-local
    vim.loop.fs_mkdir(tags_dir, 493, function(err, success)
      if err then
        vim.notify(string.format("Fail to create tags directory %s", tags_dir))
      end
    end)
  end
  vim.g.gutentags_cache_dir = tags_dir
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
  local gutentags_ctags_extra_args = {
    "--fields=+niazS",
    "--extras=+q",
    "--c++-kinds=+px",
    "--c-kinds=+px",
    "--exclude=Debug",
    "--exclude=Release",
    "--exclude=Build",
    "--exclude=build",
    "--exclude=doc",
    "--exclude=.*",
    "--exclude=third_party",
    "--exclude=bazel-*",
  }
  -- ctags_extra_args is defined in .nvimrc in order to extend g:gutentags_ctags_extra_args
  if ctags_extra_args then
    for _, arg in ipairs(ctags_extra_args) do
      table.insert(gutentags_ctags_extra_args, arg)
    end
  end
  vim.g.gutentags_ctags_extra_args = gutentags_ctags_extra_args
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

  -- Uses ivy theme
  local themes = require("telescope.themes")
  local defaults = themes.get_ivy()
  local previewers = require("telescope.previewers")
  local actions = require("telescope.actions")
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
  defaults.mappings = {
    i = {
      ["<Down>"] = actions.cycle_history_next,
      ["<Up>"] = actions.cycle_history_prev,
    },
  }
  telescope.setup({
    defaults = defaults,
  })
  local extensions = require("modules.editor.config").telescope_extensions
  for _, extension in ipairs(extensions) do
    telescope.load_extension(extension)
  end
end

function config.neogen()
  require("neogen").setup({
    snippet_engine = "luasnip",
    languages = {
      template = {
        annotation_convention = "ldoc",
      },
    },
  })
end

function config.project()
  require("project_nvim").setup({
    detection_methods = { "pattern" },
    patterns = {
      ".root",
      ".git",
      "package.json",
      "go.mod",
    },
  })
end

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

function config.nvim_lastplace()
  require("nvim-lastplace").setup()
end

function config.nvim_surround()
  require("nvim-surround").setup()
end

function config.web_tools()
  require("web-tools").setup({
    -- avoid web-tools.nvim breaking dot '.'
    keymaps = {
      repeat_rename = "",
      rename = "",
    },
  })
end

function config.mini_ai()
  require("mini.ai").setup({
    search_method = "cover",
  })
end

return config
