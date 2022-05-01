local config = {}

function config.neogit()
  vim.cmd([[silent! PackerLoad diffview.nvim]])
  GlobalPacker:setup("neogit", {
    disable_context_highlighting = true,
    integrations = {
      diffview = true,
    },
  })
end

function config.gitsigns()
  GlobalPacker:setup("gitsigns")
end

function config.octo() end

return config
