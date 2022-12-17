local fn = vim.fn

local Packer = {}

function Packer:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  -- Install plugins via ssh to pass China's Great Firewall
  -- self.mirror = "git@github.com:"
  self.mirror = "https://github.com/"
  self.repo = self.mirror .. "wbthomason/packer.nvim"
  self.path = path(data_dir, "site", "pack", "packer")
  self.install_path = path(self.path, "start", "packer.nvim")
  self.compiled = path(config_dir, "lua", "packer_compiled.lua")
  self.clone_timeout = 600

  o:initialize()
  return o
end

function Packer:setup(mod, config)
  local ok, plugin = pcall(require, mod)
  if ok then
    plugin.setup(config or {})
  end
  return plugin
end

function Packer:initialize()
  -- Install packer.nvim
  if fn.empty(fn.glob(self.install_path)) > 0 then
    print(
      string.format(
        "Installing packer.nvim: git clone --depth 1 %s %s",
        self.repo,
        self.install_path
      )
    )
    self.bootstrap = fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      self.repo,
      self.install_path,
    })
    print(self.bootstrap)
    vim.cmd([[packadd packer.nvim]])
  end
  -- Configure packer.nvim
  self.packer = require("packer")
  self.packer.init({
    compile_path = self.compiled,
    git = {
      default_url_format = self.mirror .. "%s",
      clone_timeout = self.clone_timeout, -- Prevent time out prematurely
    },
    max_jobs = 20,
  })
  self.packer.reset()
  self.packer.use({ "wbthomason/packer.nvim" })
  self.packer.use({
    "lewis6991/impatient.nvim",
    config = function()
      local ok, impatient = pcall(require, "impatient")
      if ok then
        impatient.enable_profile()
      end
    end,
  })
  -- TODO: hint CTRL
  self.packer.use({
    "folke/which-key.nvim",
    config = function()
      require("core.packer"):setup("which-key", {
        key_labels = {
          ["<Space>"] = "SPC",
          ["Cr>"] = "RET",
          ["<Tab>"] = "TAB",
        },
      })
    end,
  })
end

function Packer:load(plugins)
  local use = self.packer.use
  for repo, conf in pairs(plugins) do
    local t = vim.tbl_extend("force", { repo }, conf)
    use(t)
  end
end

function Packer:ensure_loaded(plugin)
  if not packer_plugins then
    return
  end
  if packer_plugins[plugin] and not packer_plugins[plugin].loaded then
    vim.cmd("silent! PackerLoad " .. plugin)
  end
end

local packer = Packer:new()
GlobalPacker = packer

return packer
