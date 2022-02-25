local config = {}

function config.neogit()
  vim.cmd([[silent! packadd diffview.nvim]])
  require("core.packer"):setup("neogit", {
    disable_context_highlighting = true,
    integrations = {
      diffview = true,
    },
  })
end

function config.gitsigns()
  require("core.packer"):setup("gitsigns")
end

function config.octo() end

return config
