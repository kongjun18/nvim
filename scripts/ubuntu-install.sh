#! /bin/bash
#
# Install neovim dependencies.
# Support Ubuntu 18.04 or later.

apt-get update \
&& apt-get install -y ca-certificates apt-transport-https openssh-client \
    curl wget git unzip build-essential
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get update \
&& apt-get install -y \
    python3 python3-pip python3-venv \
    nodejs \
    xclip \
    global \
    cmake gdb clangd clang-format clang-tidy bear doxygen graphviz cppcheck \
    lua-check \
    shellcheck \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get update
pip3 install pygments \
    pynvim neovim neovim-remote
if ! type snap &> /dev/null; then
  echo -e "\e[1;31msnap not found!\e[0m" > /dev/stderr
  exit 1
fi
