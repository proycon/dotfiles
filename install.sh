#!/bin/bash

cd ~
HOMEDIR=`pwd`
cd dotfiles
DOTDIR=`pwd`

ln -s $DOTDIR/vim $HOMEDIR/.vim
ln -s $DOTDIR/vimrc $HOMEDIR/.vimrc
ln -s $DOTDIR/zshrc $HOMEDIR/.zshrc
ln -s $DOTDIR/muttrc $HOMEDIR/.muttrc
ln -s $DOTDIR/signature $HOMEDIR/.signature
ln -s $DOTDIR/signature.ru $HOMEDIR/.signature.ru
ln -s $DOTDIR/signature.unilang $HOMEDIR/.signature.unilang
ln -s $DOTDIR/xinitrc $HOMEDIR/.xinitrc
ln -s $DOTDIR/openbox $HOMEDIR/.config/openbox

#ln -s $DOTDIR/oh-my-zsh $HOMEDIR/.oh-my-zsh
#ln -s $DOTDIR/oh-my-zsh $HOMEDIR/oh-my-zsh
cd $HOMEDIR
git clone git://github.com/robbyrussell/oh-my-zsh.git
ln -s oh-my-zsh .oh-my-zsh
cd .oh-my-zsh/themes
ln -s $HOMEDIR/dotfiles/proysh.zsh-theme

