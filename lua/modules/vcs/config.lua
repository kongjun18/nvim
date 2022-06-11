local config = {}

function config.neogit()
  vim.cmd([[silent! PackerLoad diffview.nvim]])
  GlobalPacker:setup("neogit", {
    disable_context_highlighting = true,
    integrations = {
      diffview = true,
    },
  })
  -- Close Neogit after git push
  local group = vim.api.nvim_create_augroup("NeogitEvents", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    pattern = "NeogitPushComplete",
    group = group,
    callback = require("neogit").close,
  })
end

function config.gitsigns()
  GlobalPacker:setup("gitsigns")
end

function config.octo() end

return config
