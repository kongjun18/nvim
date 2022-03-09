#! /bin/bash
#
# Install neovim dependencies.
# Support Debian bullseys or later.

apt-get update \
&& apt-get install -y ca-certificates apt-transport-https openssh-client \
    curl wget git unzip build-essential 
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get update \
&& apt-get install -y \
    python3 python3-pip python3-venv \
    nodejs \
    ripgrep fd-find xclip \
    global universal-ctags \
    cmake gdb clang-format clang-tidy bear doxygen graphviz cppcheck ccls \
    luarocks \
    shellcheck \
&& rm -rf /var/lib/apt/lists/*
pip3 install pygments \
    pynvim neovim neovim-remote
luarocks install luacheck
mkdir -p ~/.local/share/nvim/lsp_servers/ccls
