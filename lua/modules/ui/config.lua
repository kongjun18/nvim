local config = {}
function config.nvim_tree()
  vim.g.respect_buf_cwd = 1
  require("nvim-tree").setup({
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    hijack_directories = { enable = true, auto_open = true },
    diagnostics = {
      enable = true,
      icons = {
        hint = "󰌶 ",
        info = "󰋽 ",
        warning = " ",
        error = " ",
      },
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
        resize_window = true,
      },
    },
    renderer = {
      root_folder_label = true,
    },
    view = {
      width = 30,
      side = "left",
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
      },
    })
    vim.cmd("colorscheme nightfox")
  end
end

function config.lualine()
  local sections = {
    lualine_a = {
      "mode",
      {
        "filename",
        path = 1,
      },
    },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        symbols = {
          error = " ",
          warn = "󰌶 ",
          info = "󰋽 ",
          hint = "󰌶 ",
        },
      },
    },
    -- vim-gutentags progress
    lualine_c = { "gutentags#statusline" },
  }
  local opts = {
    sections = sections,
    inactive_sections = sections,
    -- Enable tabline
    tabline = {
      lualine_a = {
        {
          "tabs",
          mode = 2, -- 2: Shows tab_nr + tab_name
        },
      },
    },
    extensions = {
      "quickfix",
      "nvim-dap-ui",
      "fugitive",
      "nvim-tree",
      "man",
      "symbols-outline",
    },
  }
  require("lualine").setup(opts)
end

function config.fidget()
  require("fidget").setup()
end

function config.numb()
  require("numb").setup()
end

function config.notify()
  local notify = require("notify")
  notify.setup()
  vim.notify = notify
end

function config.luatab()
  require("luatab").setup()
end

function config.indent_blankline()
  local indent_blankline = require("ibl").setup({
    scope = {
      enabled = true,
    },
    exclude = {
      filetypes = {
        "log",
        "gitcommit",
        "markdown",
        "json",
        "man",
        "txt",
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
        "git",
      },
      buftypes = { "nofile", "terminal", "nowrite" },
    },
  })
  if indent_blankline then
    vim.api.nvim_create_augroup("indent_blankline", {})
    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "Refresh IndentBlankline when move cursor",
      group = "indent_blankline",
      callback = function()
        require("ibl").refresh()
      end,
    })
  end
end

-- FIXME: [Problem with make and quickfix list](https://github.com/folke/trouble.nvim/issues/87)
function config.trouble()
  require("trouble").setup()
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

function config.pqf()
  require("pqf").setup({
    signs = {
      error = { text = " " },
      warning = { text = " " },
      info = { text = "󰋽 " },
      hint = { text = "󰌶 " },
    },
  })
end

function config.barbecue()
  require("barbecue").setup({
    attach_navic = false, -- Prevent barbecue from automatically attaching nvim-navic
    create_autocmd = false, -- Prevent barbecue from updating itself automatically
    exclude_filetypes = { "gitcommit", "toggleterm" },
    show_dirname = false,
    show_basename = true,
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

function config.rainbow_delimiters()
  -- This module contains a number of default definitions
  local rainbow_delimiters = require("rainbow-delimiters")
  highlights = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterMagenta",
    "RainbowDelimiterCyan",
  }
  vim.g.rainbow_delimiters = {
    strategy = {
      [""] = rainbow_delimiters.strategy["global"],
    },
    query = {
      [""] = "rainbow-delimiters",
    },
    highlight = highlights,
  }

  local palette = require("nightfox.palette").load("dayfox")
  for _, highlight in ipairs(highlights) do
    color = string.lower(string.gsub(highlight, "RainbowDelimiter(%w+)", "%1"))
    if palette[color] then
      vim.api.nvim_set_hl(0, highlight, { fg = palette[color].base })
    end
  end
end

return config
