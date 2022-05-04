local config = {}
function config.nvim_tree()
  vim.g.nvim_tree_respect_buf_cwd = 1
  GlobalPacker:setup("nvim-tree", {
    disable_netrw = true,
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
      height = 30,
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

  GlobalPacker:setup("lualine", opts)
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
  GlobalPacker:setup("numb")
end

function config.range_highlight()
  GlobalPacker:setup("range-highlight")
end

function config.notify()
  local ok, notify = pcall(require, "notify")
  if ok then
    notify.setup()
    vim.notify = notify
  end
end

function config.gps()
  GlobalPacker:setup("nvim-gps")
end

function config.luatab()
  GlobalPacker:setup("luatab")
end

function config.indent_blankline()
  local indent_blankline = GlobalPacker:setup("indent_blankline", {
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
  GlobalPacker:setup()
end

function config.vista()
  vim.g.vista_default_executive = "ctags"
  if packer_plugins and packer_plugins["nvim-lspconfig"] then
    vim.g.vista_default_executive = "nvim_lsp"
  end
  vim.g["vista#renderer#enable_icon"] = 1
end

function config.colorizer()
  GlobalPacker:setup("colorizer", {
    "css",
    "javascript",
    "html",
  })
end

function config.dressing()
  GlobalPacker:setup("dressing")
end

function config.bqf()
  local fn = vim.fn
  function _G.qftf(info)
    local items
    local ret = {}
    if info.quickfix == 1 then
      items = fn.getqflist({ id = info.id, items = 0 }).items
    else
      items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 31
    local fnameFmt1, fnameFmt2 =
      "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local validFmt = "%s │%5d:%-3d│%s %s"
    for i = info.start_idx, info.end_idx do
      local e = items[i]
      local fname = ""
      local str
      if e.valid == 1 then
        if e.bufnr > 0 then
          fname = fn.bufname(e.bufnr)
          if fname == "" then
            fname = "[No Name]"
          else
            fname = fname:gsub("^" .. vim.env.HOME, "~")
          end
          -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
          if #fname <= limit then
            fname = fnameFmt1:format(fname)
          else
            fname = fnameFmt2:format(fname:sub(1 - limit))
          end
        end
        local lnum = e.lnum > 99999 and -1 or e.lnum
        local col = e.col > 999 and -1 or e.col
        local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
        str = validFmt:format(fname, lnum, col, qtype, e.text)
      else
        str = e.text
      end
      table.insert(ret, str)
    end
    return ret
  end
  vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

  GlobalPacker:setup("bqf", {
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
return config
