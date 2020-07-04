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
SXMO=0
if [ "$OS" = "unknown" ]; then
    if [ "$DISTRIB_ID" = "arch" ] || [ "$DISTRIB_ID" = "debian" ] || [ "$DISTRIB_ID" = "redhat" ]; then #first class
        OS=$DISTRIB_ID
    elif [ "$DISTRIB_ID" = "ubuntu" ] || [ "$DISTRIB_ID" = "linuxmint" ]; then
        OS="debian"
    elif [ "$DISTRIB_ID" = "centos" ] || [ "$DISTRIB_ID" = "fedora" ] || [ "$DISTRIB_ID" = "rhel" ]; then
        OS="redhat"
    elif [ "$DISTRIB_ID" = "postmarketos" ]; then
        OS="postmarketos"
        SXMO=1
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
        echo "Unable to detect a supported OS!">&2
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

if [ $SXMO -eq 0 ] && [ -z "$NO_DESKTOP" ]; then
    while true; do
        echo -n "Do you want to configure a desktop environment? [yn] "
        read yn
        case $yn in
            [Yy]* ) NO_DESKTOP=""; break;;
            [Nn]* ) NO_DESKTOP=1; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

if [ $SUDO -eq 1 ]; then
    if [[ "$OS" == "debian" ]]; then
        sudo apt update
        sudo apt install aptitude tmux tig neovim ncdu ranger curl wget jedi ipython ipython3 gcc autoconf-archive pandoc htop glances iotop netcat git whiptail ack jq sed fping highlight chafa
        if [ -z "$NO_DESKTOP" ]; then
            sudo apt install rxvt-unicode compton rofi dmenu jedi i3-wm i3lock openbox newsboat mpv mplayer fcitx firefox pavucontrol ncmpcpp zathura zathura-pdf-poppler gimp inkscape pamixer
            sudo apt install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 #for compiling polybar
            sudo apt install rustc cargo #for compiling alacritty and other rust stuff
        fi
    elif [[ "$OS" == "arch" ]]; then
        sudo pacman -Syyu --needed sudo openssh aspell aspell-de aspell-en aspell-es aspell-fr aspell-it aspell-nl aspell-ru audacity autoconf autoconf-archive bat bzip2 calibre cheese chromium cmake compton debootstrap deluge docker doxygen e2fsprogs encfs eslint evince fcitx fcitx-gtk3 fcitx-gtk2 fcitx-qt4 fcitx-qt4 feh ffmpeg firefox gawk gcc gdb geeqie gedit gimp git gitg glances gmp gnome-desktop gnome-common gnupg gnu-netcat gnome-settings-daemon gnome-keyring go gnutls gnuplot grep gpgme gpm groovy graphviz gstreamer gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly gzip htop hdparm hunspell i3-gaps icu ipython imagemagick iotop iperf jupyter keybase lm_sensors lsb-release lsof lua make mailcap m4 maven mesa mplayer mpv nano nautilus ncdu mosquitto mpc networkmanager newsboat ncmpcpp nmap nnn ranger okular openssl perl poppler powerline procps-ng psmisc python python-cherrypy python-lxml python-django python-setuptools python-jinja python-flask python-matplotlib python-numpy python-oauth2client python-oauthlib python-jupyter_core python-jupyter_client python-pandas python-pip python-pillow python-psutil python-requests python-seaborn python-setuptools python-virtualenv python2 python2-lxml python2-numpy python2-scipy python-yaml python2-yaml python2-virtualenv riot-desktop riot-web rofi rsync readline ruby rust rxvt-unicode rxvt-unicode-terminfo scrot semver slim smbclient sqlite tar sxiv subversion bzr mercurial telegram-desktop texlive-bin texlive-core texlive-humanities texlive-langextra texlive-latexextra texlive-pstricks texlive-pictures texlive-publishers texlive-formatsextra texlive-fontsextra texlive-bibtexextra texlive-science thunar thunderbird tig tk ttf-dejavu ttf-droid ttf-fira-code ttf-gentium ttf-khmer ttf-ubuntu-font-family ttf-tibetan-machine ttf-roboto ttf-opensans ttf-font-awesome ttf-fira-mono ttf-fira-sans ttf-linux-libertine traceroute udiskie unrar unzip urxvt-perls virtualbox vagrant usbutils v4l-utils vlc w3m wget whois wine wine-mono wine_gecko wireshark-cli xorg-server xorg-fonts-100dpi xorg-xkbutils xorg-xev xorg-xrandr xorg-xrdb xorg-xset xorg-xauth xorg-server-common xorg-setxkbmap xss-lock youtube-dl zathura zathura-pdf-poppler zip zsh tmux cups cups-filters foomatic-db antiword highlight chafa perl-authen-sasl perl-net-smtp-ssl perl-mime-tools
        sudo pacman -Syyu --needed alacritty broot rxvt-unicode tmux compton i3-gaps neovim tig i3lock ncdu ranger curl wget rofi dmenu openbox ipython pcmanfm gcc mpv autoconf-archive pandoc htop glances iotop netcat sxiv newsboat mplayer fcitx firefox pavucontrol ncmpcpp git fzf zathura zathura-pdf-poppler gimp inkscape ack bat jq fd sed sox ctags alsa-utils python-neovim archlinux-themes-slim wqy-zenhei wqy-microhei wqy-bitmapfont network-manager-applet nm-connection-editor sshfs autoconf automake pkg-config fping ripgrep exa python-language-server bash-language-server python-rope pamixer
        YAY=0
        while true; do
            echo -n "Install AUR packages? (requires yay!) [yn] "
            read yn
            case $yn in
                [Yy]* ) YAY=1; break;;
                [Nn]* ) YAY=0; break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
        if [ $YAY -eq 1 ]; then
            yay -S polybar powerline-fonts-git ttf-material-design-icons-git ttf-symbola ccls javascript-typescript-langserver ttf-nerd-fonts-input libxft-bgra.git || echo "WARNING: yay is not installed yet, do so yourself!">&2
        fi
    elif [[ "$OS" == "postmarketos" ]]; then
        sudo apk update
        sudo apk upgrade
        sudo apk add openssh vim zsh bash tmux htop bat feh newsboat weechat zathura-pdf-mupdf git tig mpv lf python3 fzf tuir espeak sxiv ncdu mpc make gcc libc-dev linux-headers libx11-dev libxft-dev libxcb-dev libxtst-dev freetype-dev libxinerama-dev || exit 2
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
git submodule init
git submodule sync
git submodule update

DOTDIR=`pwd`

if [ $SXMO -eq 1 ]; then
    ROOTNAMES=("vim" "vimrc" "zshrc" "urlview" "muttrc" "mailcap" "signature" "signature.ru.txt" "signature.unilang" "tmux.conf" "tmux-powerlinerc" "tmux")
else
    ROOTNAMES=("vim" "vimrc" "zshrc" "urlview" "muttrc" "urxvt" "gdbinit"  "mailcap" "signature" "signature.ru.txt" "signature.unilang" "xinitrc" "tmux.conf" "tmux-powerlinerc" "inputrc" "Xresources" "pylintrc" "pdbrc.py" "tmux")
fi

if [ $SXMO -eq 1 ]; then
    CONFIGNAMES=("sxiv" "tm" "ncmpcpp.config" "lf" "sxmo" "tuir" "newsboat")
elif [ -z "$NO_DESKTOP" ]; then
    CONFIGNAMES=("alacritty" "openbox" "nvim" "ranger" "polybar" "sxiv" "i3" "ipython" "tm" "ncmpcpp.config" "vifm" "lf" "broot" "zathura" "tuir" "newsboat")
else
    CONFIGNAMES=("nvim" "ranger" "ipython" "tm" "vifm" "lf" "broot")
fi

SCRIPTS=("suspend.sh" "linkhander" "lock.sh" "screencast.sh" "emojiselect" "wtime" "rotdir" "lf-select")

for NAME in ${ROOTNAMES[*]}; do
    if [ -e "$DOTDIR/$NAME" ]; then
    	echo "Linking $NAME"
        ln -sfn "$DOTDIR/$NAME" "$HOMEDIR/.$NAME"
    fi
done

for NAME in ${CONFIGNAMES[*]}; do
    if [ -e "$DOTDIR/$NAME" ]; then
    	echo "Linking $NAME"
        ln -sfn "$DOTDIR/$NAME" "$HOMEDIR/.config/$NAME"
    fi
done

for NAME in ${SCRIPTS[*]}; do
    if [ -e "$DOTDIR/$NAME" ]; then
    	echo "Linking $NAME"
        ln -sfn "$DOTDIR/$NAME" "$HOMEDIR/bin/$NAME"
    fi
done

mkdir .ncmpcpp
ln -sfn $DOTDIR/ncmpcpp.config $HOMEDIR/.ncmpcpp/config
ln -sfn $DOTDIR/tm $HOMEDIR/bin/tm
if [ -z "$NO_DESKTOP" ]; then
    ln -sfn $DOTDIR/screencast.sh $HOMEDIR/bin/screencast.sh
    ln -sfn $DOTDIR/xinitrc $HOMEDIR/.xsession
    mkdir $HOMEDIR/rofi
    ln -sfn $DOTDIR/rofi $HOMEDIR/rofi/config
fi
cd $HOMEDIR

$DOTDIR/cache-dirs.sh


if [ ! -e oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git
    ln -sfn oh-my-zsh .oh-my-zsh
else
    cd .oh-my-zsh
    git pull
fi

if [ ! -e ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    ln -s ~/dotfiles/zsh-autosuggestions
    cd -
fi

cd ~/.oh-my-zsh/themes
ln -sfn $HOMEDIR/dotfiles/proysh.zsh-theme
cd -


# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

if [ $SXMO -eq 0 ] && [ -z "$NO_DESKTOP" ]; then
    cd $DOTDIR
    if [ ! -e st ]; then
        git clone https://github.com/proycon/st
        make && cp st ~/bin/
    fi
    if [ ! -e dwm ]; then
        git clone https://github.com/proycon/dwm
        make && cp dwm ~/bin/
    fi
    if [ ! -e slstatus ]; then
        git clone https://github.com/proycon/slstatus
        make && cp slstatus ~/bin/
    fi
    cd -
fi


if [ $SXMO -eq 1 ]; then
    while true; do
        echo -n "Rebuild sxmo [yn] "
        read yn
        case $yn in
            [Yy]* ) REBUILD=1; break;;
            [Nn]* ) REBUILD=0; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    if [ $REBUILD -eq 1 ]; then
        source ~/dotfiles/build-sxmo.sh
    fi
    cd $DOTDIR
fi

