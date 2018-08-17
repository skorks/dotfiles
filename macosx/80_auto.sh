#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew install ack
brew install ag
brew install git
brew install pcre
brew install coreutils
brew install findutils
brew install tree
brew install pstree
brew install wget
brew install curl
brew install bash-completion
brew install ctags
brew install git-extras
brew install readline
brew install jq
brew install yarn --without-node

echo "[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion" | tee ~/.bash_profile

mas install 419330170 # moom
mas install 430798174 # hazeover

brew cask install google-chrome
brew cask install firefox
brew cask install iterm2
brew cask install imageoptim
brew cask install java
brew cask install vlc
brew cask install the-unarchiver
brew cask install psequel
brew cask install istat-menus
brew cask install clipy
brew cask install slack
brew cask install visual-studio-code
brew cask install skype
brew cask install github
brew cask install kitematic
brew cask install aws-vault


