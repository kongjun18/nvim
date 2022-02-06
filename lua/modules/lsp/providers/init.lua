local providers = {
  lsp_servers = require("modules.lsp.providers.lsp_servers"),
  formatters = require("modules.lsp.providers.formatters"),
  linters = require("modules.lsp.providers.linters"),
}

return providers
