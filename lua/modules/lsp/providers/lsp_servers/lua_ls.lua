--
-- lua_ls configuration
--
local M = {}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

M.opts = {
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
	end,
	settings = {
		Lua = {
			workspace = {
				ignoreDir = { ".undo" },
			},
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim", "use" },
				disable = { "lowercase-global" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

return M
