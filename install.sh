#!/bin/sh

cd ~
HOMEDIR=`pwd`
mkdir bin
mkdir .ncmpcpp
mkdir .config
mkdir .local
mkdir .local/share
cd dotfiles
DOTDIR=`pwd`


ln -sfn $DOTDIR/vim $HOMEDIR/.vim
ln -sfn $DOTDIR/vimrc $HOMEDIR/.vimrc
ln -sfn $DOTDIR/zshrc $HOMEDIR/.zshrc
ln -sfn $DOTDIR/urlview $HOMEDIR/.urlview
ln -sfn $DOTDIR/muttrc $HOMEDIR/.muttrc
ln -sfn $DOTDIR/urxvt $HOMEDIR/.urxvt
ln -sfn $DOTDIR/gdbinit $HOMEDIR/.gdbinit
ln -sfn $DOTDIR/mutt-compose.sh $HOMEDIR/bin/mutt-compose.sh
ln -sfn $DOTDIR/mutt-compose $HOMEDIR/.mutt-compose
ln -sfn $DOTDIR/mailcap $HOMEDIR/.mailcap
ln -sfn $DOTDIR/signature $HOMEDIR/.signature
ln -sfn $DOTDIR/signature.ru.txt $HOMEDIR/.signature.ru
ln -sfn $DOTDIR/signature.unilang $HOMEDIR/.signature.unilang
ln -sfn $DOTDIR/xinitrc $HOMEDIR/.xinitrc
ln -sfn $DOTDIR/openbox $HOMEDIR/.config/openbox
ln -sfn $DOTDIR/terminator $HOMEDIR/.config/terminator
ln -sfn $DOTDIR/bspwm $HOMEDIR/.config/bspwm
ln -sfn $DOTDIR/sxhkd $HOMEDIR/.config/sxhkd
ln -sfn $DOTDIR/nvim $HOMEDIR/.config/nvim
ln -sfn $DOTDIR/tilda $HOMEDIR/.config/tilda
ln -sfn $DOTDIR/ranger $HOMEDIR/.config/ranger
ln -sfn $DOTDIR/polybar $HOMEDIR/.config/polybar
ln -sfn $DOTDIR/sxiv $HOMEDIR/.config/sxiv
ln -sfn $DOTDIR/i3 $HOMEDIR/.config/i3
ln -sfn $DOTDIR/konsolerc $HOMEDIR/.config/konsolerc
ln -sfn $DOTDIR/konsole $HOMEDIR/.local/share/konsole
ln -sfn $DOTDIR/ipython $HOMEDIR/.config/ipython
ln -sfn $DOTDIR/irssi $HOMEDIR/.irssi
ln -sfn $DOTDIR/tmux.conf $HOMEDIR/.tmux.conf
ln -sfn $DOTDIR/tmux-powerlinerc $HOMEDIR/.tmux-powerlinerc
ln -sfn $DOTDIR/tm $HOMEDIR/bin/tm
ln -sfn $DOTDIR/screencash.sh $HOMEDIR/bin/screencast.sh
ln -sfn $DOTDIR/ncmpcpp.config $HOMEDIR/.ncmpcpp/config
ln -sfn $DOTDIR/pdbrc.py $HOMEDIR/.pdbrc.py
ln -sfn $DOTDIR/pylintrc $HOMEDIR/.pylintrc
ln -sfn $DOTDIR/vimperatorrc $HOMEDIR/.vimperatorrc
ln -sfn $DOTDIR/pentadactylrc $HOMEDIR/.pentadactylrc
ln -sfn $DOTDIR/pentadactyl $HOMEDIR/.pentadactyl
ln -sfn $DOTDIR/vimperator $HOMEDIR/.vimperator
ln -sfn $DOTDIR/vimperatorrc $HOMEDIR/.vimperatorrc
ln -sfn $DOTDIR/inputrc $HOMEDIR/.inputrc
ln -sfn $DOTDIR/Xresources $HOMEDIR/.Xresources
ln -sfn $DOTDIR/Proycon.colorscheme  $HOMEDIR/.kde/share/apps/konsole/Proycon.colorscheme
ln -sfn $DOTDIR/Shell.profile  $HOMEDIR/.kde/share/apps/konsole/Shell.profile
ln -sfn $DOTDIR/rofi $HOMEDIR/rofi/config
#NICKSERVPASS=`cat ~/.nickserv`
#BOUNCERPASS=`cat ~/.anaproy`
#cat $HOMEDIR/.irssi/config.masked | sed -e "s/NICKSERVPASS/$NICKSERVPASS/" -e "s/BOUNCERPASS/$BOUNCERPASS/" > $HOMEDIR/.irssi/config

#ln -s $DOTDIR/oh-my-zsh $HOMEDIR/.oh-my-zsh
#ln -s $DOTDIR/oh-my-zsh $HOMEDIR/oh-my-zsh
cd $HOMEDIR
git clone git://github.com/robbyrussell/oh-my-zsh.git
ln -sfn oh-my-zsh .oh-my-zsh
cd .oh-my-zsh/themes
ln -sfn $HOMEDIR/dotfiles/proysh.zsh-theme

