## 介绍

这是我的个人 Neovim 配置，您可以参考或使用。

## 特性

- 自动安装插件、LSP
- 纯 Lua 配置
- 模块化
- 聚焦核心功能
- 启动快速（40~50ms）
- 跨平台（Windows 和 GNU/Linux）

## 依赖

**必要依赖：**

- [最新的 neovim nightly](https://github.com/neovim/neovim/releases/tag/nightly)。

- [SourceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip)：显示图标并用作 nvim-qt 默认字体。

- 自动下载安装 LSP：

  - GNU/Linux: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
  - Windows: powershell, git, tar, and [7zip](https://www.7-zip.org/) or [peazip](https://peazip.github.io/) or [archiver](https://github.com/mholt/archiver) or [winzip](https://www.winzip.com/) or [WinRAR](https://www.win-rar.com/)
  - LSP 相关依赖，如 [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) 依赖 [go](https://go.dev/).

- 编译 [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)：

  - C 工具链，Windows 用户[参考这里](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support)。

- [Debug Adapter](https://microsoft.github.io/debug-adapter-protocol/): lldb-vscode for C++, Delve for Golang.

**可选依赖：**

- [ripgrep](https://github.com/BurntSushi/ripgrep)：提高文本查找性能。

- [fd](https://github.com/sharkdp/fd)：提高文件检索效率。

- 其他开发工具，如 linter、formatter、ctags 等。

**备注：**

- Windows 用户可以通过 [msys2](https://www.msys2.org/) 和 [chocolatey](https://chocolatey.org/install) 方便地安装依赖。

## 安装

克隆仓库到 Neovim 配置目录（Neovim 中执行`echo stdpath('config')`查看）。

```shell
git clone --depth 1 https://github.com/kongjun18/nvim.git <配置目录>
```

第一次启动时自动安装所有插件，安装完成前不要关闭 Neovim。

**备注：**

- 如果安装时退出或由于网络原因导致插件未克隆完，可能要手动删除插件，重新安装。
- mason.nvim 可能使用 npm 等工具安装 LSP，请自己配置 npm 等工具使用国内镜像。

## FAQ

1. 如何禁用 wakatime/codeium/yadm/obsidian 和调整 obsidian 路径?

在 lua/modules/config/init.lua 中将`wakatime_enable`等变量设置为`false`。

## 感谢

- [ayamir/nvimdots](https://github.com/ayamir/nvimdots)

- 所有使用到的插件
