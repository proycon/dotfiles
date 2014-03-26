#!/bin/bash

cd ~
HOMEDIR=`pwd`
mkdir bin
cd dotfiles
DOTDIR=`pwd`


ln -sT $DOTDIR/vim $HOMEDIR/.vim
ln -s $DOTDIR/vimrc $HOMEDIR/.vimrc
ln -s $DOTDIR/zshrc $HOMEDIR/.zshrc
ln -s $DOTDIR/muttrc $HOMEDIR/.muttrc
ln -s $DOTDIR/mutt-compose.sh $HOMEDIR/bin/mutt-compose.sh
ln -s $DOTDIR/mutt-compose $HOMEDIR/.mutt-compose
ln -s $DOTDIR/mailcap $HOMEDIR/.mailcap
ln -s $DOTDIR/signature $HOMEDIR/.signature
ln -s $DOTDIR/signature.ru $HOMEDIR/.signature.ru
ln -s $DOTDIR/signature.unilang $HOMEDIR/.signature.unilang
ln -sT $DOTDIR/xinitrc $HOMEDIR/.xinitrc
ln -sT $DOTDIR/openbox $HOMEDIR/.config/openbox
ln -sT $DOTDIR/irssi $HOMEDIR/.irssi
ln -s $DOTDIR/tmux.conf $HOMEDIR/.tmux.conf
ln -s $DOTDIR/tmux-powerlinerc $HOMEDIR/.tmux-powerlinerc
ln -s $DOTDIR/tm $HOMEDIR/bin/tm
NICKSERVPASS=`cat ~/.nickserv`
BOUNCERPASS=`cat ~/.anaproy`
cat $HOMEDIR/.irssi/config.masked | sed -e "s/NICKSERVPASS/$NICKSERVPASS/" -e "s/BOUNCERPASS/$BOUNCERPASS/" > $HOMEDIR/.irssi/config

#ln -s $DOTDIR/oh-my-zsh $HOMEDIR/.oh-my-zsh
#ln -s $DOTDIR/oh-my-zsh $HOMEDIR/oh-my-zsh
cd $HOMEDIR
git clone git://github.com/robbyrussell/oh-my-zsh.git
ln -sT oh-my-zsh .oh-my-zsh
cd .oh-my-zsh/themes
ln -s $HOMEDIR/dotfiles/proysh.zsh-theme

