#!/bin/bash

OS="unknown"
DISTRIB_ID="unknown"
DISTRIB_RELEASE="unknown"
if [ -e /etc/os-release ]; then
    . /etc/os-release
    DISTRIB_ID="$ID"
    DISTRIB_RELEASE="$VERSION_ID"
elif [ -e /etc/lsb-release ]; then
    . /etc/lsb-release
fi
DISTRIB_ID=$(echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]')
if [ "$OS" = "unknown" ]; then
    if [ "$DISTRIB_ID" = "arch" ] || [ "$DISTRIB_ID" = "debian" ] || [ "$DISTRIB_ID" = "redhat" ]; then #first class
        OS=$DISTRIB_ID
    elif [ "$DISTRIB_ID" = "ubuntu" ] || [ "$DISTRIB_ID" = "linuxmint" ]; then
        OS="debian"
    elif [ "$DISTRIB_ID" = "centos" ] || [ "$DISTRIB_ID" = "fedora" ] || [ "$DISTRIB_ID" = "rhel" ]; then
        OS="redhat"
    fi
fi
if [ "$OS" = "unknown" ]; then
    echo "(Fallback: Detecting OS by finding installed package manager...)">&2
    ARCH=$(which pacman 2> /dev/null)
    DEBIAN=$(which apt-get 2> /dev/null)
    REDHAT=$(which yum 2> /dev/null)
    if [ -e "$ARCH" ]; then
        OS='arch'
    elif [ -e "$DEBIAN" ]; then
        OS='debian' #ubuntu too
    elif [ -e "$REDHAT" ]; then
        OS='redhat'
    else
        echo "Unable to detect a supported OS! Perhaps your distribution is not yet supported by LaMachine? Please contact us!">&2
        exit 2
    fi
fi



SUDO=0
while true; do
    echo -n "Do you have administrative access (root/sudo) on the current system and want to install all dependencies? [yn] "
    read yn
    case $yn in
        [Yy]* ) SUDO=1; break;;
        [Nn]* ) SUDO=0; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $SUDO -eq 1 ]; then
    if [[ "$OS" == "debian" ]]; then
        sudo apt update
        sudo apt install rxvt-unicode aptitude tmux compton i3-wm tig neovim i3lock ncdu ranger curl wget jedi rofi dmenu openbox ipython ipython3 pcmanfm gcc mpv autoconf-archive pandoc htop glances iotop netcat newsboat mplayer fcitx firefox pavucontrol ncmpcpp git whiptail zathura zathura-pdf-poppler gimp inkscape ack jq sed
        sudo apt install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 #for compiling polybar
    elif [[ "$OS" == "arch" ]]; then
        sudo pacman -Syyu rxvt-unicode tmux compton i3-gaps neovim tig i3lock ncdu ranger curl wget rofi dmenu openbox ipython pcmanfm gcc mpv autoconf-archive pandoc htop glances iotop netcat sxiv newsboat mplayer fcitx firefox pavucontrol ncmpcpp git fzf zathura zathura-pdf-poppler gimp inkscape ack bat jq fd sed
    else
        echo "Distribution not supported!">&2
        sleep 10
    fi
fi

cd ~
HOMEDIR=`pwd`
mkdir bin
mkdir .config
mkdir .local
mkdir .local/share
cd dotfiles
DOTDIR=`pwd`

ROOTNAMES=("vim" "vimrc" "zshrc" "urlview" "muttrc" "urxvt" "gdbinit"  "mailcap" "signature" "signature.ru.txt" "signature.unilang" "xinitrc" "tmux.conf" "tmux-powerlinerc" "inputrc" "Xresources" "pylintrc" "pdbrc.py")

CONFIGNAMES=("openbox" "bspwm" "sxhkd" "nvim" "ranger" "polybar" "sxiv" "i3" "ipython" "tm" "ncmpcpp.config")

for NAME in $ROOTNAMES; do
    if [ -e "$DOTDIR/$NAME" ]; then
        ln -sfn "$DOTDIR/$NAME" "$HOMEDIR/.$NAME"
    fi
done

for NAME in $CONFIGNAMES; do
    if [ -e "$DOTDIR/$NAME" ]; then
        ln -sfn "$DOTDIR/$NAME" "$HOMEDIR/.config/$NAME"
    fi
done

mkdir .ncmpcpp
ln -sfn $DOTDIR/ncmpcpp.config $HOMEDIR/.ncmpcpp/config
ln -sfn $DOTDIR/tm $HOMEDIR/bin/tm
ln -sfn $DOTDIR/screencast.sh $HOMEDIR/bin/screencast.sh
ln -sfn $DOTDIR/rofi $HOMEDIR/rofi/config
cd $HOMEDIR

if [ ! -e oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git
    ln -sfn oh-my-zsh .oh-my-zsh
else
    cd .oh-my-zsh
    git pull
fi

cd .oh-my-zsh/themes
ln -sfn $HOMEDIR/dotfiles/proysh.zsh-theme
cd -
