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

function config.on_attach(client, bufnr)
  require("lsp_signature").on_attach()
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local wk = require("which-key")
  local ok, lsp_server =
    pcall(require, string.format("modules.lsp.lsp_servers.%s", client.name))

  -- Mappings.
  local opts = { buffer = bufnr }
  local keymaps = ok and lsp_server.keymaps or {}
  wk.register(keymaps, opts)

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
  vim.diagnostic.config({
    virtual_text = false,
    float = {
      source = "if_many",
    },
    signs = true,
    underline = true,
    severity_sort = true,
  })

  -- Change diagnostic symbols
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local notify = require("notify")
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({
      "ERROR",
      "WARN",
      "INFO",
      "DEBUG",
    })[result.type]
    notify({ result.message }, lvl, {
      title = "LSP | " .. client.name,
      timeout = 10000,
      keep = function()
        return lvl == "ERROR" or lvl == "WARN"
      end,
    })
  end
end

-- TODO: deduplicate repeated items. See nvim-cmp issues [Feature Request: Dedup items #511]
function config.cmp()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    return
  end
  local lspkind = require("lspkind")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
      and vim.api
          .nvim_buf_get_lines(0, line - 1, line, true)[1]
          :sub(col, col)
          :match("%s")
        == nil
  end

  cmp.setup({
    preselect = cmp.PreselectMode.None,
    completion = {
      keyword_length = 2,
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.sort_text,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        cmp.config.compare.kind,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "text",
        maxwidth = 50,
      }),
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable,
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "codeium" },
    }, {
      { name = "buffer" },
      { name = "calc" },
      { name = "path" },
    }),
  })
  cmp.setup.filetype({ "mysql", "plsql", "sql" }, {
    sources = cmp.config.sources({
      { name = "vim-dadbod-completion" },
      { name = "nvim_lsp" },
    }),
  })
  cmp.setup.filetype({ "NeogitCommitMessage", "gitcommit" }, {
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = "dictionary" },
      { name = "calc" },
    }),
  })
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

function config.luasnip()
  local ok, luasnip = pcall(require, "luasnip")
  if ok then
    vim.cmd([[hi LuaSnipChoiceNode guifg=#6080b0]]) -- Dayfox Blue
    vim.cmd([[hi LuaSnipInsertNode guifg=#E8857A]]) -- Daynight Orange
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
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { "./snippets", path(packer_dir, "start", "friendly-snippets") },
    })
    luasnip.filetype_extend("cpp", { "c" })
    luasnip_keymaps = {
      ["<C-j>"] = {
        function()
          local snip = require("luasnip")
          if snip.expand_or_jumpable() then
            snip.expand_or_jump()
          end
        end,
        mode = { "i", "s" },
        "Jump to Next Snippet Location",
      },
      ["<C-k>"] = {
        function()
          local snip = require("luasnip")
          if snip.jumpable(-1) then
            snip.jump(-1)
          end
        end,
        mode = { "i", "s" },
        "Jump to Previous Snippet Location",
      },
    }
    local wk = require("which-key")
    wk.register(luasnip_keymaps)
  end
end

function config.dictionary()
  if not DictionaryLoaded then
    vim.opt.dict:append({ path(dict_dir, "word.dict") })
    require("cmp_dictionary").update()
  end
  DictionaryLoaded = true
end

function config.null_ls()
  local construct_sources = function(...)
    local s = {}
    for i, arg in ipairs({ ... }) do
      local providers = require(arg.sources)
      for _, provider in pairs(providers) do
        local customed_opts = _G[provider .. "_opts"]
        local ok, p =
          pcall(require, string.format("%s.%s", arg.sources, provider))
        opts = ok and p.opts or customed_opts
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
  null_ls.setup({
    sources = construct_sources({
      builtin = null_ls.builtins.diagnostics,
      sources = "modules.lsp.linters",
    }, {
      builtin = null_ls.builtins.formatting,
      sources = "modules.lsp.formatters",
    }),
    -- null-ls.nvim can't use with ccls due to offset_encoding.
    -- See https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
    should_attach = function(bufnr)
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      return ft ~= "c" and ft ~= "cpp"
    end,
  })
end

function config.lsp_signature()
  require("lsp_signature").setup({
    bind = true,
    hint_prefix = "⤷",
  })
end

function config.goto_preview()
  local conf = {
    post_open_hook = function(buf, win)
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
  require("go").setup({
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
  require("mason-lspconfig").setup({
    automatic_installation = true,
  })
  config.custom_ui()
  -- NOTE: I lazyload mason.nvim after BufReadPost/BufNewFile event, but it works.
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    desc = "Attach LSP server",
    callback = function(args)
      if not null_ls_loaded then
        require("null-ls")
      end
      null_ls_loaded = true

      local ft = vim.bo.ft
      -- Avoid double setup
      if _G[ft .. "_checked"] then
        return
      end

      local lsp_servers = require("modules.lsp.lsp_servers")
      _G[ft .. "_checked"] = true
      local server_name = lsp_servers[ft]

      if not server_name then
        if require("core.util").in_blacklist(args.buf) then
          return
        end
        vim.notify(string.format("There is no %s LSP configuration", ft))
        return
      end

      local ok, lsp_server =
        pcall(require, string.format("modules.lsp.lsp_servers.%s", server_name))
      local customed = ok and lsp_server.opts or {}
      local local_customed = _G[server_name .. "_opts"]
      if local_customed then
        customed = vim.tbl_extend("force", customed, local_customed)
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local opts = vim.tbl_extend("force", {
        capabilities = capabilities,
        vim.lsp.set_log_level("debug"),
      }, customed)
      opts.on_attach = function(client, bufnr)
        config.on_attach(client, bufnr)
        if customed.on_attach then
          customed.on_attach(client, bufnr)
        end
      end
      local lspconfig = require("lspconfig")
      -- nvim-lspconfig use BufReadPost event to attach lsp client, which
      -- causes first buffer would not be attached. Add it mutually to conquer
      -- it.
      lspconfig[server_name].setup(opts)
      lspconfig[server_name].manager.try_add(args.buf)
    end,
  })
end

return config
