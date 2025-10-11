local config = {}

config.commands = {
  {
    name = "Callees",
    command = ":lua vim.lsp.buf.incoming_calls()<CR>",
  },
  {
    name = "Callers",
    command = ":lua vim.lsp.buf.outgoing_calls()<CR>",
  },
}

config.diagnostic_config = {
  virtual_text = false,
  virtual_lines = true,
  float = {
    source = "if_many",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  underline = true,
  severity_sort = true,
}

config.should_attach = function(bufnr)
  return not vim.api.nvim_buf_get_name(bufnr):match("^fugitive://")
end

function config.on_attach(client, bufnr)
  if not config.should_attach(bufnr) then
    return
  end
  vim.lsp.set_log_level(vim.log.levels.INFO)
  require("lsp_signature").on_attach({
    bind = true,
    hint_prefix = "⤷",
  })
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local wk = require("which-key")
  local ok, lsp_server =
      pcall(require, string.format("modules.lsp.lsp_servers.%s", client.name))

  -- Mappings.

  local opts = { buffer = bufnr }
  local keymaps = ok and lsp_server.keymaps or {}
  wk.add(keymaps, opts)

  -- Commands
  local default = config.commands
  local customed = ok and lsp_server.commands or nil
  local commands = customed and vim.tbl_extend("force", default, customed)
      or default
  local create_command = vim.api.nvim_buf_create_user_command
  for _, command in pairs(commands) do
    create_command(bufnr, command.name, command.command, command.opts or {})
  end
end

function config.custom_ui()
  -- Set diagnostics options
  vim.diagnostic.config(config.diagnostic_config)

  local notify = require("notify")
  local severity = {
    "ERROR",
    "WARN",
    "INFO",
    "DEBUG",
  }
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then -- true
      local lvl = severity[result.type]
      notify(result.message, lvl, {
        title = "LSP | " .. client.name,
        timeout = 5000,
        keep = function()
          return lvl == "ERROR" or lvl == "WARN"
        end,
      })
    end
  end
end

function config.cmp()
  local cmp = require("blink.cmp")

  local npairs = require("nvim-autopairs")
  cmp.setup({
    -- Appearance
    appearance = {
      nerd_font_variant = "mono",
    },

    -- Completion behavior
    completion = {
      keyword = {
        range = "prefix",
      },
      trigger = {
        show_on_insert_on_trigger_character = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        auto_show = true,
        draw = {
          columns = {
            { "kind_icon" },
            { "label",    "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 500,
      },
    },

    -- Fuzzy matching
    fuzzy = {
      use_proximity = true,
      frecency = {
        enabled = true,
      },
    },

    -- Sources configuration
    sources = {
      default = function(ctx)
        local sources = { "lsp", "path", "snippets", "buffer" }
        if vim.wo.spell or require("cmp.config.context").in_treesitter_capture('comment') then
          table.insert(sources, "dictionary")
        end

        if vim.bo.filetype == "AvanteInput" then
          table.insert(sources, "avante")
        end
        return sources
      end,
      transform_items = function(ctx, items)
        -- Only show Avante sources when typing @ in AvanteInput
        if vim.bo.filetype == "AvanteInput" then
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before_cursor = line:sub(1, col)
          local at_word = before_cursor:match(".*%f[%w@]@[%w]*$")
          if at_word then
            -- Only show Avante completions when @ word is being typed
            return vim.tbl_filter(function(item)
              return item.source_name == "Avante"
            end, items)
          end
        end
        return items
      end,
      providers = {
        avante = {
          module = 'blink-cmp-avante',
          name = 'Avante',
        },
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = -3,
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          fallbacks = {},
          score_offset = -3,
          opts = {
            -- Enable word hints in comments and markdown
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        dictionary = {
          name = "Dict",
          module = "blink-cmp-dictionary",
          min_keyword_length = 3,
          score_offset = -5,
          opts = {
            -- Specify dictionary file paths (one word per line)
            dictionary_files = {
              vim.fn.expand("~/.config/nvim/dict/words.txt"),
              "/usr/share/dict/words", -- Common system dictionary
            },
          },
        },
      },
    },

    -- Snippets
    snippets = {
      preset = "luasnip",
    },

    -- Key mappings (matching old nvim-cmp behavior)
    keymap = {
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = {
        function(instance)
          return instance.accept({
            callback = npairs.on_confirm_done
          })
        end,
        "fallback",
      },

      -- Tab: sidekick suggestions -> snippet forward -> completion selection
      ["<Tab>"] = {
        function(cmp_instance)
          -- First, try sidekick next edit suggestion (Cursor-like Tab behavior)
          if require("sidekick").nes_jump_or_apply() then
            return true
          end
          -- Then handle completion menu navigation
          if cmp_instance.is_visible() then
            return cmp_instance.select_next()
          end
          -- Otherwise, show completion if there are words before cursor
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          local has_words_before = col ~= 0
              and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
              == nil
          if has_words_before then
            return cmp_instance.show()
          end
          -- Finally, try snippet forward
          return cmp_instance.snippet_forward()
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp_instance)
          if cmp_instance.is_visible() then
            return cmp_instance.select_prev()
          else
            return cmp_instance.snippet_backward()
          end
        end,
        "fallback",
      },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    -- Signature help
    signature = {
      enabled = true,
    },
  })
end

function config.luasnip()
  local luasnip = require("luasnip")
  vim.api.nvim_set_hl(0, "LuaSnipChoiceNode", {
    fg = "#6080b0",
  })
  vim.api.nvim_set_hl(0, "LuaSnipInsertNode", {
    fg = "#E8857A",
  })
  local types = require("luasnip.util.types")
  luasnip.config.setup({
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "LuaSnipChoiceNode" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "LuaSnipInsertNode" } },
        },
      },
    },
  })

  require("luasnip.loaders.from_snipmate").lazy_load({
    paths = {
      path(config_dir, "snippets"),
      path(lazy_dir, "vim-snippets", "snippets"),
    },
  })
end

function config.none_ls()
  local construct_sources = function(...)
    local s = {}
    for _, arg in ipairs({ ... }) do
      local providers = require(arg.sources)
      for _, provider in pairs(providers) do
        local customed_opts = _G[provider .. "_opts"]
        local ok, p =
            pcall(require, string.format("%s.%s", arg.sources, provider))
        local opts = ok and p.opts or customed_opts
        if opts then
          if customed_opts then
            opts = vim.tbl_extend("force", opts, customed_opts)
          end
          table.insert(s, arg.builtin[provider].with(opts))
        else
          table.insert(s, arg.builtin[provider])
        end
      end
    end
    return s
  end

  local null_ls = require("null-ls")
  local opts = {
    sources = construct_sources({
      builtin = null_ls.builtins.diagnostics,
      sources = "modules.lsp.linters",
    }, {
      builtin = null_ls.builtins.formatting,
      sources = "modules.lsp.formatters",
    }),
    should_attach = config.should_attach,
  }
  null_ls.setup(opts)
end

function config.goto_preview()
  local conf = {
    post_open_hook = function(buf) -- function(buf, win)
      vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        ":quit<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "<ESC>",
        ":quit<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_create_autocmd("WinLeave", {
        once = true,
        callback = function()
          if vim.fn.maparg("q", "n") ~= "" then
            vim.api.nvim_buf_del_keymap(buf, "n", "q")
          end
          if vim.fn.maparg("<ESC>", "n") ~= "" then
            vim.api.nvim_buf_del_keymap(buf, "n", "<ESC>")
          end
        end,
      })
    end,
  }
  local ok, telescope = pcall(require, "telescope.themes")
  if ok then
    conf.references = {
      telescope = telescope.get_ivy({ hide_preview = false }),
    }
  end
  require("goto-preview").setup(conf)
end

function config.go()
  -- Limit the CPU usage of the Go toolchain to reduce system load
  -- on low-performance desktop.
  local util = require("core.util")
  local nproc = util.nproc()
  local cpu_frequency = util.cpu_frequency()
  if cpu_frequency < 3.0 or nproc <= 8 then
    vim.env.GOMAXPROCS = math.floor(nproc / 2)
  end
  require("go").setup({
    diagnostic = config.diagnostic_config,
    lsp_inlay_hints = {
      enable = false,
    },
    lsp_keymaps = false,
    lsp_cfg = false,
  })
end

function config.mason_lspconfig()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  config.custom_ui()

  require("mason-lspconfig").setup({
    automatic_installation = true,
    handlers = {
      function(server_name)
        local ok, lsp_server = pcall(
          require,
          string.format("modules.lsp.lsp_servers.%s", server_name)
        )
        local customed = ok and lsp_server.opts or {}
        local local_customed = _G[server_name .. "_opts"]
        if local_customed then
          customed = vim.tbl_extend("force", customed, local_customed)
        end
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local opts = vim.tbl_extend("force", {
          capabilities = capabilities,
        }, customed)
        opts.on_attach = function(client, bufnr)
          config.on_attach(client, bufnr)
          if customed.on_attach then
            customed.on_attach(client, bufnr)
          end
        end
        require("lspconfig")[server_name].setup(opts)
      end,
    },
  })

  -- NOTE: I lazyload mason.nvim after BufReadPost/BufNewFile event, but it works.
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    desc = "Load null-ls on file open",
    callback = function(args)
      if not NullLSLoaded then
        require("null-ls")
      end
      NullLSLoaded = true
    end,
  })

  -- Format requires LSP servers or formatters,
  -- so it should not reside in core/autocmd.lua.
  vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format the buffer on save",
    group = "format",

    pattern = path(config_dir, "*.lua"),
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

function config.outline()
  require("outline").setup({
    symbols = {
      File = { icon = " ", hl = "@text.uri" },
      Module = { icon = " ", hl = "@namespace" },
      Namespace = { icon = "", hl = "@namespace" },
      Package = { icon = " ", hl = "@namespace" },
      Class = { icon = " ", hl = "@type" },
      Method = { icon = " ", hl = "@method" },
      Property = { icon = " ", hl = "@method" },
      Field = { icon = " ", hl = "@field" },
      Constructor = { icon = " ", hl = "@constructor" },
      Enum = { icon = "練", hl = "@type" },
      Interface = { icon = "練", hl = "@type" },
      Function = { icon = " ", hl = "@function" },
      Variable = { icon = " ", hl = "@constant" },
      Constant = { icon = " ", hl = "@constant" },
      String = { icon = " ", hl = "@string" },
      Number = { icon = " ", hl = "@number" },
      Boolean = { icon = "◩ ", hl = "@boolean" },
      Array = { icon = " ", hl = "@constant" },
      Object = { icon = " ", hl = "@type" },
      Key = { icon = " ", hl = "@type" },
      Null = { icon = "ﳠ ", hl = "@type" },
      EnumMember = { icon = " ", hl = "@field" },
      Struct = { icon = " ", hl = "@type" },
      Event = { icon = " ", hl = "@type" },
      Operator = { icon = " ", hl = "@operator" },
      TypeParameter = { icon = " ", hl = "@parameter" },
      Component = { icon = "", hl = "@function" },
      Fragment = { icon = "", hl = "@constant" },
    },
  })
end

return config
