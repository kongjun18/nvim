#! /bin/bash
#
# Install neovim dependencies.
# Support Debian bullseys or later.

# Neovim plugins dependencies
apt install -y curl wget
apt install -y git gcc make python3 pip nodejs npm
pip3 install pynvim
# Tag system
apt install -y global universal-ctags
pip3 install pygments
# C++ development
apt install -y ccls cmake gdb clang-format clang-tidy bear doxygen graphviz
mkdir -p ~/.local/share/nvim/lsp_servers/ccls
# Lua development
apt install -y unzip luarocks
# Github mirrors:
#     - https://hub.fastgit.org
#     - https://github.cnpmjs.org
wget https://hub.fastgit.org/JohnnyMorganz/StyLua/releases/download/v0.11.2/stylua-0.11.2-linux.zip -O /tmp/stylua.zip \
    && unzip -o /tmp/stylua.zip -d /usr/local/bin \
    && chmod a+x /usr/local/bin/stylua
luarocks install ldoc luacheck
# Javascript development
npm install -g eslint standard jsdoc
# Bash shell
apt install -y shellcheck
# System utilites
apt install -y ripgrep fd-find xclip
apt autoremove -y
