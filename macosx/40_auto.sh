#!/usr/bin/env bash

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew cask install 1password 
brew cask install dropbox
brew cask install authy
brew install git
brew install mas

curl https://raw.githubusercontent.com/skorks/dotfiles/master/.gitconfig | tee ~/.gitconfig

softwareupdate -l
softwareupdate -i -a

mkdir -p projects/mine
git clone git@github.com:skorks/dotfiles.git ~/projects/mine/dotfiles

eval "$(ssh-agent -s)"
mkdir -p ~/.ssh
cp ~/projects/mine/dotfiles/.ssh/config ~/.ssh/config
ssh-add -K ~/.ssh/id_rsa
