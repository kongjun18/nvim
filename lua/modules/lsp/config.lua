local config = {}

local function snippet_path(dir)
	local g = require("core.global")
	local s = g.path_sep
	local m = g.modules_dir
	return string.format("%s%s%s%s%s", m, s, "lsp", s, dir)
end

config.dictionaries = {
	["*"] = "word.dict",
}

config.snippet_path = snippet_path("snippets")

config.keymaps = {
	["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
	["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
	["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
	["gt"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
	["gs"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto References" },
	["gn"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Goto Next Diagnostic" },
	["gN"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Goto Previous  Diagnostic" },
	["gK"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
	["gf"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Buffer" },
	["<space>e"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Show Diagnostic Message In Float Window" },
	["<space>q"] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Show Diagnostic Message In Location List" },
	["<space>wa"] = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder" },
	["<space>wr"] = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder" },
	["<space>wl"] = {
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		"Show Workspace Folders",
	},
	["<space>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename Symbol" },
	["<space>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
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
	require("lsp_signature").on_attach()

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local providers = require("modules.lsp.providers")

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { buffer = bufnr }
	local wk = require("which-key")
	local default = require("modules.lsp.config").keymaps
	local customed = providers.keymaps[client.name]
	local keymaps = customed and vim.tbl_extend("force", default, customed) or default
	wk.register(keymaps, opts)

	-- Commands
	default = require("modules.lsp.config").commands
	customed = providers.commands[client.name]
	local commands = customed and vim.tbl_extend("force", default, customed) or default
	add_command = vim.api.nvim_buf_add_user_command
	for _, command in pairs(commands) do
		add_command(bufnr, command.name, command.command, command.opts or {})
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

	-- Use nvim-notify to display LSP messages
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
		local providers = require("modules.lsp.providers")
		local servers = providers.servers
		for _, server in pairs(servers) do
			local lsp_installer_servers = require("nvim-lsp-installer.servers")
			local server_available, requested_server = lsp_installer_servers.get_server(server)
			if server_available then
				requested_server:on_ready(function()
					local customed = providers.opts[server]
					local default = {
						on_attach = config.on_attach,
						capabilities = require("cmp_nvim_lsp").update_capabilities(
							vim.lsp.protocol.make_client_capabilities()
						),
					}
					local opts = customed and vim.tbl_extend("force", default, customed) or default
					requested_server:setup(opts)
				end)
				if not requested_server:is_installed() then
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
-- FIXME: cmp-cmdline breaks sometimes
function config.cmp()
	local ok, cmp = pcall(require, "cmp")
	if not ok then
		return
	end

	local lspkind = require("lspkind")

	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	cmp.setup({
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
				with_text = false,
				maxwidth = 50,
			}),
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		-- FIXME: fail to map keymaps
		-- perhaps related to  Recursive binding outputs =v:lua.vim.json.decode('"\r"') in infinite loop #744
		--
		-- NOTE: nvim-cmp will remove all default mapping in future
		-- See nvim-cmp PR [Discussion: Remove all default mapping #739]
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
			{ name = "cmp_git" },
		}, {
			-- { name = "dictionary" },
			-- { name = "spell" },
		}),
	})
	cmp.setup.cmdline("/", {
		sources = {
			{ name = "buffer" },
		},
	})
	cmp.setup.cmdline(":", {
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
		-- Mappings:
		--     <C-j>: Jump to the next placeholder
		--     <C-k>: Jump to the previous placeholder
		local t = function(str)
			return vim.api.nvim_replace_termcodes(str, true, true, true)
		end
		vim.keymap.set({ "i", "s" }, t("<C-j>"), function()
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end)
		vim.keymap.set({ "i", "s" }, t("<C-k>"), function()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end)

		luasnip.filetype_extend("all", { "_" })
		luasnip.filetype_extend("cpp", { "c" })
		require("luasnip.loaders.from_vscode").lazy_load()
	end
end

function config.cmp_git()
	require("core.packer"):setup("cmp_git")
end

function config.dictionary()
	local dict2path = function(dict)
		return dict_dir .. path_sep .. dict
	end

	local dictionaries = require("modules.lsp.config").dictionaries
	-- Avoud re-modifing the dictionaries path after :PackerCompile
	if not loaded_dictionaries then
		for ft, dict in pairs(dictionaries) do
			dictionaries[ft] = dict2path(dict)
		end
	end

	if require("core.packer"):setup("cmp_dictionary", {
		dic = dictionaries,
	}) then
		loaded_dictionaries = true
	end
end

-- TODO: install formatters automatically
function config.format_installer()
	require("core.packer"):setup("format-installer")
end

-- TODO: configure linters
-- TODO: how to install linters automatically?
function config.null_ls()
	local ok, null_ls = pcall(require, "null-ls")
	if not ok then
		return
	end

	local formatter_install = require("format-installer")

	local sources = {}
	for _, formatter in ipairs(formatter_install.get_installed_formatters()) do
		local config = { command = formatter.cmd }
		table.insert(sources, null_ls.builtins.formatting[formatter.name].with(config))
	end

	null_ls.setup({
		sources = sources,
	})
end

function config.lsp_signature()
	require("core.packer"):setup("lsp_signature")
end

return config
