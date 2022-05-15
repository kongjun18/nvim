# Introduction

This is my personal Neovim configuration, you can use it directly.

**Chinese user see this [中文文档](./README.zh.md)**

# Features

- Install plugins and LSP automatically
- Pure Lua configuration
- Modular design
- Focus on core programming functionalities
- Fast startup time (40~50ms)
- Cross platform (Windows and GNU/Linux)
- Download plugins normally in China

# Prerequisites

**Must**:

- [Latest neovim nightly](https://github.com/neovim/neovim/releases/tag/nightly).

- [SourceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip): Display icons and default fonts for nvim-qt.

- Install LSP automatically:
  - GNU/Linux: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
  - Windows:  powershell, git, tar, and [7zip](https://www.7-zip.org/) or [peazip](https://peazip.github.io/) or [archiver](https://github.com/mholt/archiver) or [winzip](https://www.winzip.com/) or [WinRAR](https://www.win-rar.com/)
  - Other: Lsp specific Prerequisites such as CMake. Please read LSP's document.

- Compile [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)：
  - C toolchain, Windows user see [this](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support).

**Optional**

- [ripgrep](https://github.com/BurntSushi/ripgrep): Improve text search performance.
- [fd](https://github.com/sharkdp/fd)：Improve file search performance.
- Other development tools you need.

**NOTE:**

- Windows user can install dependencies using [msys2](https://www.msys2.org/) and [chocolatey](https://chocolatey.org/install).
- Scripts in [scripts](./scripts) may help you install dependencies on GNU/Linux system. Installation scripts perhaps pollute your environment, please be **careful**!


# Installation
By default, download plugins from Github via SSH. Please configure SSH under the guidance of the following.

1. Add github to your ~/.ssh/known_hosts.

   ```shell
   ssh-keyscan github.com >> ~/.ssh/known_hosts
   ```

2. Clone this repository to your Neovim configuration directory.

   ```shell
   git clone --depth 1 git@github.com:kongjun18/nvim.git <configuration directory>
   ```

All plugins are automatically installed on first startup, do not close Neovim until the installation is complete. After installation, manually execute `:TSInstall maintained ` to install all treesitter parser under maintenance.

**NOTE:**

- If you exit during installation or the plugin is not cloned due to network reasons, you may need to manually delete the plugin and reinstall it.

# Credits

- [ayamir/nvimdots](https://github.com/ayamir/nvimdots)
- All plugins my configuration used
