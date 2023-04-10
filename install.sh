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


if [ -z "$SUDO" ]; then
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
fi

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

if [ "$INTERACTIVE" = "0" ]; then
    export DEBIAN_FRONTEND=noninteractive
    export TZ=Europe/Amsterdam
    APT_YES="-y"
else
    APT_YES=""
fi


if [ $SUDO -eq 1 ]; then
    if [[ "$OS" == "debian" ]]; then
        sudo -E apt-get $APT_YES update
        sudo -E apt-get $APT_YES  install aptitude tmux tig neovim ncdu ranger curl wget gcc autoconf-archive pandoc htop glances iotop netcat git whiptail ack jq sed fping highlight chafa gawk
        if [ -z "$NO_DESKTOP" ]; then
            sudo -E apt-get $APT_YES install rxvt-unicode compton rofi dmenu i3-wm i3lock openbox newsboat mpv mplayer fcitx firefox pavucontrol ncmpcpp zathura zathura-pdf-poppler gimp inkscape pamixer dunst fonts-firacode
            sudo -E apt-get $APT_YES install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 #for compiling polybar
            sudo -E apt-get $APT_YES install rustc cargo #for compiling alacritty and other rust stuff
        fi
    elif [[ "$OS" == "arch" ]]; then
        sudo pacman -Syyu --needed sudo openssh aspell aspell-de aspell-en aspell-es aspell-fr aspell-it aspell-nl aspell-ru audacity autoconf autoconf-archive bat bzip2 calibre cheese chromium cmake compton debootstrap deluge doxygen e2fsprogs encfs evince fcitx fcitx-gtk3 fcitx-gtk2 feh ffmpeg firefox gawk gcc gdb geeqie gedit gimp git gitg glances gmp gnome-common gnupg gnu-netcat gnome-settings-daemon gnome-keyring go gnutls gnuplot grep gpgme gpm groovy graphviz gstreamer gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly gzip htop hdparm hunspell icu ipython imagemagick iotop iperf jupyter keybase lm_sensors lsb-release lsof lua make mailcap m4 maven mesa mplayer mpv nano nautilus ncdu mosquitto mpc networkmanager newsboat ncmpcpp nmap nnn ranger okular openssl perl poppler powerline procps-ng psmisc python python-cherrypy python-lxml python-django python-setuptools python-jinja python-flask python-matplotlib python-numpy python-oauth2client python-oauthlib python-jupyter_core python-jupyter_client python-pandas python-pip python-pillow python-psutil python-requests python-seaborn python-setuptools python-virtualenv python-yaml rofi rsync readline ruby rust rxvt-unicode rxvt-unicode-terminfo scrot semver slim smbclient sqlite tar sxiv subversion bzr mercurial telegram-desktop texlive-bin texlive-core texlive-humanities texlive-langextra texlive-latexextra texlive-pstricks texlive-pictures texlive-publishers texlive-formatsextra texlive-fontsextra texlive-bibtexextra texlive-science thunar thunderbird tig tk ttf-dejavu ttf-droid ttf-fira-code ttf-khmer ttf-ubuntu-font-family ttf-tibetan-machine ttf-roboto ttf-opensans ttf-font-awesome ttf-fira-mono ttf-fira-sans ttf-linux-libertine traceroute udiskie unrar unzip urxvt-perls virtualbox vagrant usbutils v4l-utils vlc w3m wget whois wireshark-cli xorg-server xorg-fonts-100dpi xorg-xkbutils xorg-xev xorg-xrandr xorg-xrdb xorg-xset xorg-xauth xorg-server-common xorg-setxkbmap xss-lock youtube-dl zathura zathura-pdf-poppler zip zsh tmux cups cups-filters foomatic-db antiword highlight chafa perl-authen-sasl perl-net-smtp-ssl perl-mime-tools dunst inetutils
        sudo pacman -Syyu --needed alacritty tmux picom neovim tig i3lock ncdu ranger curl wget rofi dmenu openbox ipython pcmanfm gcc mpv autoconf-archive pandoc htop glances iotop netcat sxiv newsboat mplayer fcitx firefox pavucontrol ncmpcpp git fzf zathura zathura-pdf-poppler gimp inkscape ack bat jq fd sed sox ctags alsa-utils python-neovim wqy-zenhei wqy-microhei wqy-bitmapfont network-manager-applet nm-connection-editor sshfs autoconf automake pkg-config fping ripgrep exa bash-language-server python-rope pamixer noto-fonts-emoji otf-fira-mono ttf-fira-code xclip xsel scrot clutter encfs pipewire-pulse pipewire-alsa xdg-desktop-portal flatpak tldr yt-dlp powertop buku ueberzug github-cli telegram-desktop gucharmap leafpad
        sudo pacman- Syyu --needed xorg-startx xorg-xinit xf86-video-intel mesa
        sudo pacman -Syyu --needed alsa-firmware sof-firmware alsa-ucm-conf
        sudo pacman -Syyu --needed cargo rust go gdb nodejs
        sudo pacman -Syyu --needed pyright flake8 eslint cppcheck rustfmt prettier python-pylint
        sudo pacman -Syyu --needed sway swaylock swaybg swayidle mako bemenu wtype wofi xdg-desktop-portal-wlr libpipewire02 slurp grim wl-clipboard i3status xorg-xwayland imv
        sudo pacman -Syyu --needed weechat msmtp-mta calcurse afew #neomutt
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
            yay -S hyprland-git waybar-hyprland-git lf-sixel-git lsix-git otf-nerd-fonts-fira-mono powerline-fonts-git ttf-material-design-icons-git ttf-symbola ccls javascript-typescript-langserver ttf-nerd-fonts-input libxft-bgra || echo "WARNING: yay is not installed yet, do so yourself!">&2
        fi
    elif [[ "$OS" == "postmarketos" ]]; then
        sudo apk update
        sudo apk upgrade
        sudo apk add openssh vim zsh bash tmux htop bat feh newsboat weechat zathura-pdf-mupdf git tig mpv lf python3 fzf tuir espeak sxiv ncdu mpc make gcc libc-dev linux-headers libx11-dev libxft-dev libxcb-dev libxtst-dev freetype-dev libxinerama-dev wqy-zenhei font-fira-mono-nerd font-fira-code || exit 2
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
    ROOTNAMES=("vim" "vimrc" "zshrc" "urlview" "muttrc" "mailcap" "signature" "signature.ru.txt" "signature.unilang" "tmux.conf" "tmux-powerlinerc" "tmux" "tigrc")
else
    ROOTNAMES=("vim" "vimrc" "zshrc" "urlview" "muttrc" "urxvt" "gdbinit"  "mailcap" "signature" "signature.ru.txt" "signature.unilang" "xinitrc" "tmux.conf" "tmux-powerlinerc" "inputrc" "Xresources" "pylintrc" "pdbrc.py" "tmux" "tigrc")
fi

if [ $SXMO -eq 1 ]; then
    CONFIGNAMES=("sxiv" "tm" "ncmpcpp.config" "lf" "sxmo" "tuir" "newsboat" "user-dirs.dirs")
elif [ -z "$NO_DESKTOP" ]; then
    CONFIGNAMES=("kitty" "alacritty" "openbox" "nvim" "ranger" "polybar" "sxiv" "i3" "ipython" "tm" "ncmpcpp.config" "vifm" "lf" "broot" "zathura" "tuir" "newsboat" "dunst" "sway" "mako" "i3status" "foot" "rofi" "user-dirs.dirs")
else
    CONFIGNAMES=("nvim" "ranger" "ipython" "tm" "vifm" "lf" "broot" "hypr")
fi

SCRIPTS=("suspend.sh" "linkhander" "lock.sh" "screencast.sh" "emojiselect" "wtime" "rotdir" "lf-select" "updatemail.sh" "darkmode.sh" "lightmode.sh")

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
ln -sfn $DOTDIR/defaults.list $HOMEDIR/.config/mimeapps.list
ln -sfn $HOMEDIR/.config/mimeapps.list $HOMEDIR/.local/share/applications/mimeapps.list #legacy
ln -sfn $DOTDIR/tm $HOMEDIR/bin/tm
if [ -z "$NO_DESKTOP" ]; then
    ln -sfn $DOTDIR/screencast.sh $HOMEDIR/bin/screencast.sh
    ln -sfn $DOTDIR/xinitrc $HOMEDIR/.xsession
    mkdir $HOMEDIR/rofi
    mkdir -p $HOMEDIR/.config/rofi
    ln -sfn $DOTDIR/rofi $HOMEDIR/rofi/config.rasi
    ln -sfn $DOTDIR/rofi $HOMEDIR/.config/rofi/config.rasi
fi
cd $HOMEDIR

$DOTDIR/cache-dirs.sh


if [ ! -e oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git
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
    ln -sf ~/dotfiles/sxmo/profile ~/.profile
    cd $DOTDIR
fi
 
~/dotfiles/darkmode.sh
