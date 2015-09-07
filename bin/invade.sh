#!/usr/bin/env sh

set -ex

PREFIX="$HOME"
DOTFILES="$PREFIX/dotfiles"
BACKUPS="$PREFIX/backups"

function sym () {
  src="$DOTFILES/$1"
  dest="$PREFIX/$2"

  if [ -e "$dest" ]; then
    newdest="$BACKUPS/$(basename $dest)-$(date +%s)"
    mv "$dest" "$newdest"
    echo "> Moved $dest to $newdest"
  fi

  ln -s "$src" "$dest"
}

if [ ! -e "$DOTFILES" ]; then
  echo "error: dotfiles/ needs to reside in $PREFIX"
  exit 1
fi

mkdir -p "$PREFIX"
mkdir -p "$BACKUPS/vim_backups"

sym vim            .vim
sym vim/vimrc      .vimrc
sym bashrc         .bashrc
sym ackrc          .ackrc
sym ctags          .ctags
sym zshrc          .zshrc
sym emacs.d        .emacs.d
sym tmux           .tmux
sym tmux/tmux.conf .tmux.conf

touch $DOTFILES/bash/local
touch $DOTFILES/vim/local.vim

# Vim
BUNDLE_DIR=$DOTFILES/vim/bundle
if [ ! -e $BUNDLE_DIR/ctrlp.vim.git ]; then
  mkdir -p $BUNDLE_DIR
  git clone git://github.com/kien/ctrlp.vim.git $BUNDLE_DIR/ctrlp.vim.git
fi

# IntelliJ Idea
sym idea/idea.vmoptions  Library/Preferences/IdeaIC15/idea.vmoptions
sym idea/idea.properties Library/Preferences/IdeaIC15/idea.properties

echo "> Invasion successful!"
