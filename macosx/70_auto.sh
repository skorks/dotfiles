#!/usr/bin/env bash

brew install zsh
brew install zsh-completions

# configure zsh
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
sudo chsh -s /usr/local/bin/zsh $USER
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm .zshrc.pre-oh-my-zsh
curl https://raw.githubusercontent.com/skorks/dotfiles/master/.zshrc | tee ~/.zshrc


brew cask install macvim

git clone git@github.com:skorks/better-vim-config.git ~/projects/mine/better-vim-config
~/projects/mine/better-vim-config/install.sh
