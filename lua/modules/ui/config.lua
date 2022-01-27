local config = {}
function config.nvim_tree()
	require("core.packer"):setup("nvim-tree", {
		disable_netrw = true,
		hijack_netrw = true,
		open_on_setup = false,
		ignore_ft_on_setup = {},
		auto_close = true,
		open_on_tab = false,
		hijack_cursor = true,
		update_cwd = false,
		update_to_buf_dir = { enable = true, auto_open = true },
		diagnostics = {
			enable = false,
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
			fox = "dayfox",
			styles = {
				comments = "italic",
				keywords = "bold",
			},
			inverse = {
				match_paren = true,
			},
		})
		nightfox.load()
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

	local ok, gps = pcall(require, "nvim-gps")
	if ok then
		table.insert(opts.sections.lualine_c, 1, { gps.get_location, cond = gps.is_available })
	end

	require("core.packer"):setup("lualine", opts)
end

function config.lens()
	vim.g["lens#disabled_filetypes"] = {
		"list", "gitcommit", "fugitive", "man", "tagbar",
		"qf", "", "help", "diff", "undotree", "leaderf",
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
				"log", "gitcommit", "markdown", "json", "man",
				"txt", "vista", "help", "todoist", "NvimTree",
				"TelescopePrompt", "undotree", "", "list",
				"qf", "diff", "undotree", "leaderf", "git",
		},
		buftype_exclude = { "nofile", "terminal", "nowrite" },
	})
	if indent_blankline then
		vim.cmd([[autocmd CursorMoved * IndentBlanklineRefresh]])
	end
end

-- TODO: enhance quickfix UI
-- TODO: map j/k to move between quickfix entries
function config.bqf()
	-- function _G.qftf(info)
	-- 	local items
	-- 	local ret = {}
	-- 	local fn = vim.fn
	-- 	if info.quickfix == 1 then
	-- 		items = fn.getqflist({ id = info.id, items = 0 }).items
	-- 	else
	-- 		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	-- 	end
	-- 	local limit = 31
	-- 	local fname_fmt1, fname_fmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
	-- 	local valid_fmt = "%s │%5d:%-3d│%s %s"
	-- 	for i = info.start_idx, info.end_idx do
	-- 		local e = items[i]
	-- 		local fname = ""
	-- 		local str
	-- 		if e.valid == 1 then
	-- 			if e.bufnr > 0 then
	-- 				fname = fn.bufname(e.bufnr)
	-- 				if fname == "" then
	-- 					fname = "[No Name]"
	-- 				else
	-- 					fname = fname:gsub("^" .. vim.env.HOME, "~")
	-- 				end
	-- 				-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
	-- 				if #fname <= limit then
	-- 					fname = fname_fmt1:format(fname)
	-- 				else
	-- 					fname = fname_fmt2:format(fname:sub(1 - limit))
	-- 				end
	-- 			end
	-- 			local lnum = e.lnum > 99999 and -1 or e.lnum
	-- 			local col = e.col > 999 and -1 or e.col
	-- 			local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
	-- 			str = valid_fmt:format(fname, lnum, col, qtype, e.text)
	-- 		else
	-- 			str = e.text
	-- 		end
	-- 		table.insert(ret, str)
	-- 	end
	-- 	return ret
	-- end
	-- vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
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

return config
