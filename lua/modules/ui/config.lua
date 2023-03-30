local config = {}
function config.nvim_tree()
  vim.g.respect_buf_cwd = 1
  require("nvim-tree").setup({
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    hijack_directories = { enable = true, auto_open = true },
    diagnostics = {
      enable = true,
      icons = { hint = "", info = "", warning = "", error = "" },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
    system_open = { cmd = nil, args = {} },
    filters = { dotfiles = false, custom = {} },
    git = { enable = true, ignore = true, timeout = 500 },
    actions = {
      open_file = {
        resize_window = false,
      },
    },
    view = {
      width = 30,
      -- height = 30,
      hide_root_folder = false,
      side = "left",
      mappings = { custom_only = false, list = {} },
      number = false,
      relativenumber = false,
      signcolumn = "yes",
    },
    trash = { cmd = "trash", require_confirm = true },
  })
end

function config.nightfox()
  local ok, nightfox = pcall(require, "nightfox")
  if ok then
    nightfox.setup({
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
        },
        inverse = {
          match_paren = true,
        },
        modules = {
          cmp = true,
          dap_ui = true,
          fidget = true,
          gitsign = true,
          notify = true,
          telescope = true,
          tsrainbow = true,
          whichkey = true,
          navic = true,
        },
      },
    })
    vim.cmd("colorscheme dayfox")
  end
end

function config.lualine()
  local navic = require("nvim-navic")
  local opts = {
    sections = {
      lualine_a = {
        "mode",
        {
          "filename",
          path = 1,
        },
      },
    },
    extensions = {
      "quickfix",
      "nvim-dap-ui",
      "fugitive",
      "nvim-tree",
      "man",
    },
  }
  require("lualine").setup(opts)
end

function config.fidget()
  require("fidget").setup()
end

function config.lens()
  vim.g["lens#disabled_filetypes"] = {
    "list",
    "gitcommit",
    "fugitive",
    "dap-repl",
    "man",
    "qf",
    "",
    "help",
    "diff",
  }
  vim.g["lens#disabled_buftypes"] = { "nofile", "", "terminal", "nowrite" }
end

function config.numb()
  require("numb").setup()
end

function config.range_highlight()
  require("range-highlight").setup()
end

function config.notify()
  local ok, notify = pcall(require, "notify")
  if ok then
    notify.setup()
    vim.notify = notify
  end
end

function config.luatab()
  require("luatab").setup()
end

function config.indent_blankline()
  local indent_blankline = require("indent_blankline").setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = {
      "log",
      "gitcommit",
      "markdown",
      "json",
      "man",
      "txt",
      "vista",
      "help",
      "todoist",
      "NvimTree",
      "TelescopePrompt",
      "undotree",
      "",
      "list",
      "qf",
      "diff",
      "undotree",
      "leaderf",
      "git",
    },
    buftype_exclude = { "nofile", "terminal", "nowrite" },
  })
  if indent_blankline then
    vim.cmd([[autocmd CursorMoved * IndentBlanklineRefresh]])
  end
end

-- FIXME: [Problem with make and quickfix list](https://github.com/folke/trouble.nvim/issues/87)
function config.trouble()
  require("trouble").setup()
end

function config.vista()
  vim.g.vista_stay_on_open = 0
  vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }
  vim.g["vista#executive#ctags#support_json_format"] = 1
  -- Vscode-like icons
  local overrided_icons = {
    var = "",
    variable = "",
    variables = "",
    const = "",
    constant = "",
    constructor = "",
    enum = "",
    enummember = "",
    enumerator = "",
    module = "",
    modules = "",
    struct = "פּ",
    class = "ﴯ",
    field = "ﰠ",
    fields = "ﰠ",
    interface = "",
  }
  vim.g["vista#renderer#icons"] = vim.tbl_extend(
    "force",
    vim.g["vista#renderer#icons"],
    overrided_icons
  )
end

function config.colorizer()
  require("colorizer").setup({
    "css",
    "javascript",
    "html",
    "vue",
  })
end

function config.dressing()
  require("dressing").setup()
end

function config.bqf()
  require("bqf").setup({
    preview = {
      should_preview_cb = function(bufnr, qwinid)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if
          bufname:match("^fugitive://")
          and not vim.api.nvim_buf_is_loaded(bufnr)
        then
          if bqf_pv_timer and bqf_pv_timer:get_due_in() > 0 then
            bqf_pv_timer:stop()
            bqf_pv_timer = nil
          end
          bqf_pv_timer = vim.defer_fn(function()
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd(("do fugitive BufReadCmd %s"):format(bufname))
            end)
            require("bqf.preview.handler").open(qwinid, nil, true)
          end, 60)
        end
        return true
      end,
    },
  })
end

config.bufferline = function()
  local bufferline = require("modules.ui.internal.bufferline")
  require("bufferline").setup({
    options = {
      groups = {
        options = {
          toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
        },
        items = {
          {
            name = "syslib",
            auto_close = true,
            matcher = function(buf)
              return buf.path:match("/usr/include/.*")
            end,
          },
          {
            name = "golib",
            auto_close = true,
            matcher = function(buf)
              return buf.path:match(path(vim.env.GOROOT, "src", ".*.go"))
            end,
          },
          {
            name = "gopkg",
            auto_close = true,
            matcher = function(buf)
              return buf.path:match(path(vim.env.GOPATH, "pkg", ".*.go"))
            end,
          },
          {
            name = "docs",
            matcher = function(buf)
              return buf.path:match("man://.*")
                or buf.path:match("%.md")
                or buf.path:match("%.txt")
                  and buf.filename ~= "CMakeLists.txt"
            end,
          },
        },
      },
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "center",
        },
      },
      custom_filter = function(buf, _)
        return bufferline.in_tab(buf) and not bufferline.in_blacklist(buf)
      end,
      close_command = function(buf)
        local tab = vim.api.nvim_get_current_tabpage()
        bufferline.remove_buf(buf, tab)
      end,
      -- Avoid auxiliary windows switching to the target buffer.
      --
      -- The typical situation:
      -- 1. Open(go to) vista window.
      -- 2. Click other buffer, the vista window switch to the target buffer.
      --
      -- left_mouse_command funciton avoids this embarrassing situation.
      --     1. If the current window's buffer is not in the black list, switch
      --        to the target buffer normally.
      --     2. Otherwise,
      --            1. For vista window, the left adjacent window switch to the target buffer.
      --            2. For other window, do nothing.
      left_mouse_command = function(buf)
        local current = vim.fn.bufnr()
        if bufferline.in_blacklist(current) then
          local winnr = vim.fn.winnr
          local win_nr = winnr()
          if
            winnr("k") == win_nr
            and winnr("j") == win_nr
            and winnr("l") == win_nr
            and winnr("h") ~= win_nr
          then -- The leftmost window
            local win_id = vim.fn.win_getid(winnr("h"))
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            if not bufferline.in_blacklist(buf_id) then
              vim.fn.win_execute(win_id, "buffer " .. buf)
              vim.fn.win_gotoid(win_id)
            end
          end
        else -- Normal code path
          vim.cmd("buffer " .. buf)
        end
      end,
    },
  })

  -- Both buffer and tab number are ascending. Thus it is safe to don't remove
  -- non-existed entries in the buf2tab dict. This timer is used to delete
  -- auxiliary buffers like TelescopePrompt.
  vim.fn.timer_start(
    5 * 60 * 1000, -- 5m
    bufferline.remove_nonexisted_entries,
    { ["repeat"] = -1 }
  )
end

function config.pqf()
  require("pqf").setup({
    signs = {
      error = " ",
      warning = " ",
      info = " ",
      hint = " ",
    },
  })
end

function config.murmur()
  require("murmur").setup({
    cursor_rgb = {
      guibg = "#edebfc", -- MatchParen
    },
    cursor_rgb_always_use_config = true, -- if set to `true`, then always use `cursor_rgb`.
    exclude_filetypes = { "TelescopePrompt", "vista" },
    callbacks = {
      -- to trigger the close_events of vim.diagnostic.open_float.
      function()
        -- Close floating diag. and make it triggerable again.
        vim.w.diag_shown = false
      end,
    },
  })
  -- To create IDE-like no blinking diagnostic message with `cursor` scope. (should be paired with the callback above)
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = FOO,
    pattern = "*",
    callback = function()
      -- skip when a float-win already exists.
      if vim.w.diag_shown then
        return
      end
      -- open float-win when hovering on a cursor-word.
      if vim.w.cursor_word ~= "" then
        vim.diagnostic.open_float()
        vim.w.diag_shown = true
      end
    end,
  })
end

function config.barbecue()
  require("barbecue").setup({
    attach_navic = false, -- Prevent barbecue from automatically attaching nvim-navic
    create_autocmd = false, -- Prevent barbecue from updating itself automatically
  })
  -- Get better performance
  vim.api.nvim_create_autocmd({
    "WinResized",
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",
  }, {
    group = vim.api.nvim_create_augroup("barbecue.updater", {}),
    callback = function()
      require("barbecue.ui").update()
    end,
  })
end
return config
