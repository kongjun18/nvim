local config = {}
config.dictionaries = {
  ["*"] = "word.dict",
}

config.keymaps = {
  ["gp"] = {
    ["name"] = "+Preview symbol",
    ["i"] = {
      "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
      "Preview Implementation",
    },
    ["d"] = {
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      "Preview Definition",
    },
    ["r"] = {
      "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
      "Preview References",
    },
    ["c"] = {
      "<cmd>lua require('goto-preview').close_all_win()<CR>",
      "Preview Close",
    },
    ["t"] = {
      "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
      "Preview Type Definition",
    },
  },
  ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
  ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
  ["gC"] = {
    function()
      local ft = vim.api.nvim_buf_get_option(0, "filetype")
      if ft == "c" or ft == "cpp" then
        ccls_call(true)
      else
        vim.lsp.buf.outgoing_calls()
      end
    end,
    "Outgoing Calls",
  },
  ["gc"] = {
    function()
      local ft = vim.api.nvim_buf_get_option(0, "filetype")
      if ft == "c" or ft == "cpp" then
        ccls_call(false)
      else
        vim.lsp.buf.incoming_calls()
      end
    end,
    "Incoming Calls",
  },
  ["gi"] = {
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    "Goto Implementation",
  },
  ["gt"] = {
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    "Goto Type Definition",
  },
  ["gs"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto References" },
  ["gn"] = {
    "<cmd>lua vim.diagnostic.goto_next()<CR>",
    "Goto Next Diagnostic",
  },
  ["gN"] = {
    "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    "Goto Previous  Diagnostic",
  },
  ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
  ["gf"] = {
    function()
      GlobalPacker:ensure_loaded("null-ls.nvim")
      vim.lsp.buf.format({ async = true })
    end,
    "Format Buffer",
  },
  ["ga"] = {
    function()
      GlobalPacker:ensure_loaded("null-ls.nvim")
      vim.lsp.buf.code_action()
    end,
    "Code Action",
  },
  ["g"] = {
    ["f"] = {
      "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
      "Format Range",
      mode = "v",
    },
  },
  ["<space>e"] = {
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    "Show Diagnostic Message In Float Window",
  },
  ["<space>q"] = {
    "<cmd>lua vim.diagnostic.setqflist()<CR>",
    "Show Diagnostic Message In Location List",
  },
  ["<space>wa"] = {
    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    "Add Workspace Folder",
  },
  ["<space>wr"] = {
    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    "Remove Workspace Folder",
  },
  ["<space>wl"] = {
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    "Show Workspace Folders",
  },
  ["<space>rn"] = {
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    "Rename Symbol",
  },
}

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
-- TODO: Refine lspconfig diagnostics UI
function config.on_attach(client, bufnr)
  local ok, lsp_signature = pcall(require, "lsp_signature")
  if ok then
    lsp_signature.on_attach()
  end
  local ok, navic = pcall(require, "nvim-navic")
  if ok then
    navic.attach(client, bufnr)
  end
  local lsp_servers = require("modules.lsp.providers").lsp_servers

  -- Mappings.
  local opts = { buffer = bufnr }
  local wk = require("which-key")
  local default = require("modules.lsp.config").keymaps
  local customed = lsp_servers.keymaps[client.name]
  local keymaps = customed and vim.tbl_extend("force", default, customed)
    or default
  wk.register(keymaps, opts)

  -- Commands
  default = require("modules.lsp.config").commands
  customed = lsp_servers.commands[client.name]
  local commands = customed and vim.tbl_extend("force", default, customed)
    or default
  create_command = vim.api.nvim_buf_create_user_command
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

  local ok, notify = require("notify")
  if ok then
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
end

function config.lsp_installer()
  local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
  if ok then
    lsp_installer.settings({
      ui = {
        icons = {
          server_installed = "✓",
          server_pending = "➜",
          server_uninstalled = "✗",
        },
      },
    })

    local config = require("modules.lsp.config")
    local lsp_servers = require("modules.lsp.providers").lsp_servers
    local servers = lsp_servers.servers
    for _, server in pairs(servers) do
      local lsp_installer_servers = require("nvim-lsp-installer.servers")
      local server_available, requested_server =
        lsp_installer_servers.get_server(
          server
        )
      if server_available then
        requested_server:on_ready(function()
          local customed = lsp_servers.opts[server] or {}
          vim.cmd("PackerLoad cmp-nvim-lsp")
          local capabilities = require("cmp_nvim_lsp").update_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
          require("cmp_nvim_lsp").update_capabilities(capabilities)
          local opts = vim.tbl_extend("force", {
            capabilities = capabilities,
          }, customed)
          opts.on_attach = function(client, bufnr)
            config.on_attach(client, bufnr)
            if customed.on_attach then
              customed.on_attach(client, bufnr)
            end
          end
          requested_server:setup(opts)
        end)
        if not requested_server:is_installed() then
          vim.notify(
            "Install Language Server : " .. requested_server.name,
            "WARN",
            { title = "Language Servers" }
          )
          requested_server:install()
        end
      end
    end

    config.custom_ui()
  end
end

-- TODO: deduplicate repeated items. See nvim-cmp issues [Feature Request: Dedup items #511]
-- TODO: use ctags source when LSP is disabled
-- TODO: wrap require
function config.cmp()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    return
  end
  local lspkind = require("lspkind")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
      and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
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
    }, {
      { name = "buffer" },
      { name = "calc" },
      { name = "path" },
    }, {
      -- { name = "dictionary" },
      -- { name = "spell" },
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
  cmp.setup.cmdline("/", {
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
      paths = { "./snippets" },
    })
  end
end

function config.dictionary()
  local dict2path = function(dict)
    return dict_dir .. path_sep .. dict
  end

  local dictionaries = require("modules.lsp.config").dictionaries
  -- Avoid re-modifying the dictionaries path after :PackerCompile
  if not loaded_dictionaries then
    for ft, dict in pairs(dictionaries) do
      dictionaries[ft] = dict2path(dict)
    end
  end

  if GlobalPacker:setup("cmp_dictionary", {
    dic = dictionaries,
  }) then
    loaded_dictionaries = true
  end
end

function config.null_ls()
  local ok, null_ls = pcall(require, "null-ls")
  if not ok then
    return
  end

  local sources = {}
  local providers = require("modules.lsp.providers")
  local formatters = providers.formatters
  for _, formatter in pairs(formatters.formatters) do
    local opt = formatters.opts[formatter]
    if opt then
      table.insert(sources, null_ls.builtins.formatting[formatter].with(opt))
    else
      table.insert(sources, null_ls.builtins.formatting[formatter])
    end
  end
  null_ls.setup({
    sources = sources,
    should_attach = function(bufnr)
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      return ft ~= "c" and ft ~= "cpp"
    end,
  })
end

function config.lsp_signature()
  GlobalPacker:setup("lsp_signature", {
    bind = true,
    hint_prefix = "⤷",
  })
end
function config.goto_preview()
  local conf = {
    post_open_hook = function(buf)
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
          vim.api.nvim_buf_del_keymap(buf, "n", "q")
          vim.api.nvim_buf_del_keymap(buf, "n", "<ESC>")
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
  GlobalPacker:setup("goto-preview", conf)
end

function config.nvim_lint()
  local ok, lint = pcall(require, "lint")
  if not ok then
    return
  end
  lint.linters_by_ft = require("modules.lsp.providers").linters.linters
  vim.api.nvim_create_autocmd(
    { "BufWritePost", "InsertLeave" },
    { command = "lua require('lint').try_lint()" }
  )
  lint.try_lint()
end

function config.go()
  GlobalPacker:setup("go", {
    lsp_keymaps = false,
  })
end

return config
