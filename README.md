## Introduction

This is my personal Neovim configuration, you can use it directly.

**Chinese user see this [中文文档](./README.zh.md)**

## Features

- Install plugins and LSP automatically
- Pure Lua configuration
- Modular design
- Focus on core programming functionalities
- Fast startup time (40~50ms)
- Cross platform (Windows and GNU/Linux)

## Prerequisites

**Must**:

- [Latest neovim nightly](https://github.com/neovim/neovim/releases/tag/nightly).

- [SourceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip): Display icons and default fonts for nvim-qt.

- Install LSP automatically:

  - GNU/Linux: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
  - Windows: powershell, git, tar, and [7zip](https://www.7-zip.org/) or [peazip](https://peazip.github.io/) or [archiver](https://github.com/mholt/archiver) or [winzip](https://www.winzip.com/) or [WinRAR](https://www.win-rar.com/)
  - Lsp specific Prerequisites: for example, [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) needs [go](https://go.dev/).

- Compile [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)：

  - C toolchain, Windows user see [this](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support).

- [Debug Adapter](https://microsoft.github.io/debug-adapter-protocol/): lldb-vscode for C++, Delve for Golang.

**Optional**

- [ripgrep](https://github.com/BurntSushi/ripgrep): Improve text search performance.
- [fd](https://github.com/sharkdp/fd)：Improve file search performance.
- Other development tools you need.

**NOTE:**

- Windows user can install dependencies using [msys2](https://www.msys2.org/) and [chocolatey](https://chocolatey.org/install).

## Installation

Clone this repository to your Neovim configuration directory.

```shell
git clone --depth 1 https://github.com:kongjun18/nvim.git <configuration directory>
```

All plugins are automatically installed on first startup, do not close Neovim until the installation is complete.

**NOTE:**

- If you exit during installation or the plugin is not cloned due to network reasons, you may need to manually delete the plugin and reinstall it.

## FAQ

1. How to disable and enable wakatime/codeium/yadm/obsidian and custom obsidian path?

Set variables in lua/modules/config/init.lua like `wakatime_enable` to `false`.

## Credits

- [ayamir/nvimdots](https://github.com/ayamir/nvimdots)
- All plugins my configuration used
