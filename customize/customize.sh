#! /bin/bash

#
# Install dependencies & helper tools
#
apt-get update
apt-get install -y --no-install-recommends \
        zsh ncdu less tree htop nano emacs-nox kitty-terminfo
apt clean
rm -rf /var/lib/apt/lists/*

# Install atuin <3
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)

#
# Zsh setup
#

# Install antigen
mkdir "$HOME/.antigen/"
curl -L git.io/antigen > "$HOME/.antigen/antigen.zsh"

# Install zshrc
cp -vf /tmp/customize/zshrc "$HOME/.zshrc"

# Setup atuin
mkdir -p "$HOME/.config/atuin"
cp -vf /tmp/customize/atuin.toml "$HOME/.config/atuin/config.toml"

# Making zsh the default shell
chsh -s /bin/zsh root


#
# Emacs setup
#

# Fetching Centaur Emacs
git clone --depth 1 https://github.com/seagle0128/.emacs.d.git ~/.emacs.d
