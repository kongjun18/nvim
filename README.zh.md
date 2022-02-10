# 介绍

- 自动安装插件、LSP
- 纯 Lua 配置
- 模块化
- 聚焦核心功能
- 启动快速（40ms）
- 跨平台（Windows 和 GNU/Linux）
- 无需翻墙



#  依赖

**必要依赖：**

- [neovim nightly(v0.7)](https://github.com/neovim/neovim/releases/tag/nightly)。

- 自动下载安装 LSP：

  - GNU/Linux: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
  - Windows:  powershell, git, tar, and [7zip](https://www.7-zip.org/) or [peazip](https://peazip.github.io/) or [archiver](https://github.com/mholt/archiver) or [winzip](https://www.winzip.com/) or [WinRAR](https://www.win-rar.com/)
  - 其他依赖，如 C++ LSP [ccls](https://github.com/MaskRay/ccls) 需要 CMake 等，参考 LSP 文档或查看`:LspInstallInfo`信息。

- 编译 [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)：

  - C 工具链，Windows 用户[参考这里](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support)。

**可选依赖：**

- [ripgrep](https://github.com/BurntSushi/ripgrep)：提高文本查找性能。
- [fd](https://github.com/sharkdp/fd)：提高文件检索效率。
- [SourceCodePro](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip)：显示图标并用作 nvim-qt 默认字体。
- 其他开发工具，如 linter、formatter、ctags 等。

**备注：**

- 本配置仅在 GNU/Linux 上测试过，但 Windows 应该也能够使用。
- Windows 用户可以通过 [chocolatey](https://chocolatey.org/install) 包管理器方便地安装依赖。
- [scripts](./scripts) 目录中提供了 Debian/Fedora 平台上的依赖安装脚本（C++/Lua/JS）。安装脚本可能污染用户系统，请谨慎使用。



# 安装

确保网络通畅，能够正常访问 Github，如果不能请参考 README *使用 Github 镜像* 一节。

备份旧配置，将本仓库克隆到配置目录。

```shell
git clone --depth 1 https://github.com/kongjun18/nvim ~/.config/nvim
# 如果无法访问 Github，从 Gitee 克隆。
# git clone --depth 1 https://gitee.com/kongjun18/nvim ~/.config/nvim
```

第一次启动时自动安装所有插件，安装完成前不要关闭 neovim。安装完成后手动执行`:TSInstall maintained `安装所有维护中的 treesitter parser。启动时检测预配置的 LSP 是否安装，未安装则自动异步安装。

**备注：**

- 如果安装时退出或由于网络原因导致插件未克隆完，可能要手动删除插件，重新安装。

- 如果 Github 镜像崩溃或限制流量导致插件安装失败，请更换镜像或换个时间安装插件。



# Github 镜像

在 lua/core/packer.lua 中修改`Packer:new()`的镜像 URL，自动从 Github 镜像安装插件和 treesitter。

```shell
function Packer:new()
  -- some code
  self.mirror = "https://github.com.cnpmjs.org" -- 使用 Github 镜像地址，不带 / 后缀
  -- some code
end
```

nvim-lsp-installer 从 Github 下载 ccls 源代码并编译安装，无法访问 Github 导致安装失败。手动安装 ccls，并在安装目录（Linux 上是 ~/.local/share/nvim/lsp_servers）中创建目录 ccls，nvim-lsp-installer 会自动在标准系统目录查询 ccls 可执行文件并配置 nvim-lspconfig。

```shell
mkdir -p ~/.local/share/nvim/lsp_servers/ccls
```

**备注：**

- nvim-lsp-installer 可能使用 npm 等工具安装 LSP，请自己配置 npm 等工具使用国内镜像。



# 感谢

- [ayamir/nvimdots](https://github.com/ayamir/nvimdots)
- [LunarVim/LunarVim](https://github.com/LunarVim/LunarVim)
- 所有使用到的插件
