# 介绍

这是我的个人 Neovim 配置，您可以参考或使用。

# 特性

- 自动安装插件、LSP
- 纯 Lua 配置
- 模块化
- 聚焦核心功能
- 启动快速（40~50ms）
- 跨平台（Windows 和 GNU/Linux）
- 无需翻墙



#  依赖

**必要依赖：**

- [最新的 neovim nightly](https://github.com/neovim/neovim/releases/tag/nightly)。

- [SourceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip)：显示图标并用作 nvim-qt 默认字体。

- 自动下载安装 LSP：

  - GNU/Linux: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
  - Windows:  powershell, git, tar, and [7zip](https://www.7-zip.org/) or [peazip](https://peazip.github.io/) or [archiver](https://github.com/mholt/archiver) or [winzip](https://www.winzip.com/) or [WinRAR](https://www.win-rar.com/)
  - 其他依赖，如 C++ LSP [ccls](https://github.com/MaskRay/ccls) 需要 CMake 等，参考 LSP 文档或查看`:LspInstallInfo`信息。

- 编译 [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)：

  - C 工具链，Windows 用户[参考这里](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support)。


**可选依赖：**

- [ripgrep](https://github.com/BurntSushi/ripgrep)：提高文本查找性能。
- [fd](https://github.com/sharkdp/fd)：提高文件检索效率。
- 其他开发工具，如 linter、formatter、ctags 等。

**备注：**

- Windows 用户可以通过 [msys2](https://www.msys2.org/) 和 [chocolatey](https://chocolatey.org/install) 方便地安装依赖。
- [scripts](./scripts) 目录中提供了 GNU/Linux 平台上的依赖安装脚本（C++/Lua/Bash）。安装脚本可能污染用户系统，请谨慎使用。



# 安装
默认使用 SSH 从 Github 下载依赖插件，请先配置 SSH：
1. [将 SSH 公钥添加到 Github 帐号](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)。
2. 配置 \~/.ssh/config（Windows 平台：C:\Users\\<user\>\.ssh\config），添加以下代码（\~/.ssh/id_rsa.pub 替换为你的你的 SSH 公钥文件）。
```
Host github
    Hostname github.com
    User git
    IdentityFile ~/.ssh/id_rsa.pub
```
3. 克隆仓库到 Neovim 配置目录（Neovim 中执行`echo stdpath('config')`查看）。
```shell
git clone --depth 1 git@github.com:kongjun18/nvim.git <配置目录>
# git clone --depth 1 git@github.com:kongjun18/nvim.git <配置目录>
# git clone --depth 1 git@github.com:kongjun18/nvim.git <配置目录>
```

第一次启动时自动安装所有插件，安装完成前不要关闭 Neovim。安装完成后手动执行`:TSInstall maintained `安装所有维护中的 treesitter parser。

启动时检测预配置的 LSP 是否安装，未安装则自动异步安装。nvim-lsp-installer 从 Github 下载 ccls 源代码并编译安装，无法访问 Github 导致安装失败。手动安装 ccls，并在 nvim-lsp-installer LSP 安装目录（Neovim 中执行`echo stdpath('data') .. '/lsp_servers'`查看）中创建目录 ccls，nvim-lsp-installer 会通过 PATH 变量查询 ccls 可执行文件并配置 nvim-lspconfig。

GNU/Linux 上创建目录：
```shell
mkdir -p ~/.local/share/nvim/lsp_servers/ccls
```
Windows 
```cmd
md C:\Users\<user>\AppData\Local\nvim-data\lsp_servers\ccls
```

**备注：**

- 如果安装时退出或由于网络原因导致插件未克隆完，可能要手动删除插件，重新安装。
- nvim-lsp-installer 可能使用 npm 等工具安装 LSP，请自己配置 npm 等工具使用国内镜像。


# 感谢

- [ayamir/nvimdots](https://github.com/ayamir/nvimdots)
- 所有使用到的插件
