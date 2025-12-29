-- ========== per-project shada (与 project.nvim 集成) ==========
-- 作用：每个“项目根(cwd)”使用独立 shadafile，隔离 jumplist/marks/search 历史并持久化。
-- 依赖：project.nvim 负责改变 cwd；本脚本通过 DirChanged 感知并切换 shada。

local M = {
  -- 保存目录：放到 XDG state 下，避免往仓库写文件
  base_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "shadafiles"),
  -- 切换时是否清一下当前窗口的 jumplist，避免“视觉残影”
  clear_window_jumps = true,
}

-- 根据 cwd 生成该项目的 shada 路径
local function shada_path_for(cwd)
  local ok_hash, h = pcall(function() return vim.fn.sha256(cwd) end)
  local key = ok_hash and h or cwd:gsub("[^%w_.-]+", "_")
  local dir = vim.fs.joinpath(M.base_dir, key)
  local file = vim.fs.joinpath(dir, "main.shada")
  if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
  return file
end

-- 切换当前会话到指定 cwd 的 shada
local function switch_to_shada(cwd)
  if not cwd or cwd == "" then return end
  -- 先写回当前会话，避免丢失
  pcall(vim.cmd, "silent! wshada")

  local file = shada_path_for(vim.fs.normalize(cwd))
  if vim.o.shadafile == file then return end

  vim.o.shadafile = file
  if M.clear_window_jumps then pcall(vim.cmd, "silent! clearjumps") end
  -- 强制用磁盘覆盖内存态，确保“项目间不合并”
  pcall(vim.cmd, "silent! rshada!")
end

-- 记录当前已应用的 cwd，避免重复切换
local CURRENT = nil
local function ensure_for(cwd)
  if cwd and cwd ~= "" and cwd ~= CURRENT then
    CURRENT = cwd
    switch_to_shada(cwd)
  end
end

-- 1) 启动时为初始 cwd 选择 shada
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("per_project_shada_bootstrap", { clear = true }),
  callback = function()
    -- project.nvim 默认会在启动后设置 cwd；这里拿当前 cwd 即可
    ensure_for(vim.uv.cwd())
  end,
})

-- 2) 监听目录变化（project.nvim 切项目根时会触发），据此切换 shada
vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("per_project_shada_switch", { clear = true }),
  pattern = { "global", "tabpage", "window", "auto" },
  callback = function()
    -- :help DirChanged 显示 v:event.cwd 为新目录（非 Pre 事件）
    local new_cwd = (vim.v.event and vim.v.event.cwd) or vim.fn.getcwd(-1, -1)
    ensure_for(new_cwd)
  end,
})

-- 3) 退出前写回
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("per_project_shada_save", { clear = true }),
  callback = function() pcall(vim.cmd, "silent! wshada") end,
})

-- 4) 手动命令：如果你在自定义“切项目”流程里想显式调用
vim.api.nvim_create_user_command("ProjectShadaRescan", function()
  ensure_for(vim.fn.getcwd(-1, -1))
end, {})
