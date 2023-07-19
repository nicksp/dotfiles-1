#!/bin/bash

# Installs Homebrew, Git, git-friendly, Node.js, etc.

# Ask for the administrator password upfront
sudo -v

# Install Homebrew
#command -v brew >/dev/null 2>&1 || ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

# Update Homebrew and already installed packages
brew update

# GNU core utilities (those that come with macOS are outdated)
brew install coreutils

# GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
brew install tree

# Git
brew install git

# git-friendly
brew install git-friendly/git-friendly/git-friendly

# Extend global $PATH
echo -e "setenv PATH $HOME/dotfiles/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" | sudo tee /etc/launchd.conf

# Everything else
brew install bat
brew install fd
brew install fzf && $(brew --prefix)/opt/fzf/install
brew install macos-trash
brew install micro
brew install proselint
brew install ripgrep
brew install starship
brew install tldr
brew install git-delta
brew install bat-extras
brew install zsh-syntax-highlighting

# Node
# n, Node version manager
brew install n
npm config set loglevel warn

# Npm
npm i -g npm-upgrade

# Remove outdated versions from the cellar
brew cleanup
