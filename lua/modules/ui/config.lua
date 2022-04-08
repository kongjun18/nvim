local config = {}
function config.nvim_tree()
  vim.g.nvim_tree_respect_buf_cwd = 1
  require("core.packer"):setup("nvim-tree", {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    update_to_buf_dir = { enable = true, auto_open = true },
    diagnostics = {
      enable = true,
      update_cwd = true,
      icons = { hint = "", info = "", warning = "", error = "" },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
    system_open = { cmd = nil, args = {} },
    filters = { dotfiles = false, custom = {} },
    git = { enable = true, ignore = true, timeout = 500 },
    view = {
      width = 30,
      height = 30,
      hide_root_folder = false,
      side = "left",
      auto_resize = false,
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
      },
    })
    vim.cmd("colorscheme dayfox")
  end
end

function config.lualine()
  local opts = {
    sections = {
      lualine_c = {
        "lsp_progress",
      },
    },
  }

  if pcall(require, "treesitter") then
    local ok, gps = pcall(require, "nvim-gps")
    if ok then
      table.insert(
        opts.sections.lualine_c,
        #opts.sections.lualine_c,
        { gps.get_location, cond = gps.is_available }
      )
    end
  end

  require("core.packer"):setup("lualine", opts)
end

function config.lens()
  vim.cmd([[silent! PackerLoad animate.vim]])
  vim.g["lens#disabled_filetypes"] = {
    "list",
    "gitcommit",
    "fugitive",
    "man",
    "tagbar",
    "qf",
    "",
    "help",
    "diff",
    "undotree",
    "leaderf",
  }
  vim.g["lens#disabled_buftypes"] = { "nofile", "", "terminal", "nowrite" }
end

function config.numb()
  require("core.packer"):setup("numb")
end

function config.range_highlight()
  require("core.packer"):setup("range-highlight")
end

function config.notify()
  local ok, notify = pcall(require, "notify")
  if ok then
    notify.setup()
    vim.notify = notify
  end
end

function config.gps()
  require("core.packer"):setup("nvim-gps")
end

function config.luatab()
  require("core.packer"):setup("luatab")
end

function config.indent_blankline()
  local indent_blankline = require("core.packer"):setup("indent_blankline", {
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
  require("core.packer"):setup()
end

function config.vista()
  vim.g.vista_default_executive = "ctags"
  if packer_plugins and packer_plugins["nvim-lspconfig"] then
    vim.g.vista_default_executive = "nvim_lsp"
  end
  vim.g["vista#renderer#enable_icon"] = 1
end

function config.colorizer()
  require("core.packer"):setup("colorizer", {
    "css",
    "javascript",
    "html",
  })
end

function config.dressing()
  require("core.packer"):setup("dressing")
end

return config
