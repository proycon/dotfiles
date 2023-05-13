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
    if [ "$OS" = "debian" ]; then
        sudo -E apt-get $APT_YES update
        sudo -E apt-get $APT_YES  install aptitude tmux tig neovim ncdu ranger curl wget gcc autoconf-archive pandoc htop glances iotop netcat git whiptail ack jq sed fping highlight chafa gawk
        if [ -z "$NO_DESKTOP" ]; then
            sudo -E apt-get $APT_YES install rxvt-unicode compton rofi dmenu i3-wm i3lock openbox newsboat mpv mplayer fcitx firefox pavucontrol ncmpcpp zathura zathura-pdf-poppler gimp inkscape pamixer dunst fonts-firacode
            sudo -E apt-get $APT_YES install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 #for compiling polybar
            sudo -E apt-get $APT_YES install rustc cargo #for compiling alacritty and other rust stuff
        fi
    elif [ "$OS" = "arch" ]; then
        #this is much more elaborate than the others because this is my main distro

        PACMAN="sudo pacman -Syyu --needed"
        #core
        $PACMAN base-devel bash busybox bzip2 coreutils e2fsprogs fzf gnupg gnutls gzip hdparm htop iotop iperf less lm_sensors lsb-release lshw lsof make nano neovim openssh openssl procps-ng psmisc readline rsync sudo tar time tmux tree udiskie vi zip zsh
        #networking
        $PACMAN curl encfs fping inetutils netcat networkmanager nfs-utils nm-connection-editor nmap nmap smbclient sshfs traceroute usbutils wget whois wireshark-cli
        #version control
        $PACMAN git mercurial subversion tig
        #audio
        $PACMAN alsa-firmware alsa-ucm-conf audacity gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer mpc ncmpcpp pamixer pavucontrol pipewire-alsa pipewire-pulse sof-firmware
        #dev: python
        $PACMAN ipython jupyter-nbconvert jupyter-notebook jupyterlab python python-cherrypy python-django python-flask python-jinja python-jupyter-client python-jupyter-core python-lxml python-matplotlib python-numpy python-oauth2client python-oauthlib python-pandas python-pillow python-pip python-psutil python-requests python-scikit-learn python-scipy python-seaborn python-setuptools python-setuptools python-sphinx python-virtualenv python-yaml
        #dev: rust
        $PACMAN cargo gdb go nodejs rust rust-src
        #dev: C/C++
        $PACMAN autoconf autoconf-archive automake cmake ctags doxygen gdb gmp icu m4 meson ninja pkg-config valgrind
        #dev: various programming languages
        $PACMAN go groovy jdk-openjdk lua maven nodejs perl ruby
        #dev: distro specific
        $PACMAN abuild apk-tools debootstrap pmbootstrap
        #dev: linters, formatters
        $PACMAN bash-language-server cppcheck eslint flake8 prettier pyright python-pylint rustfmt
        #communication
        $PACMAN aerc mailcap mosquitto msmtp-mta newsboat weechat
        #libs
        $PACMAN perl-mime-tools perl-net-smtp-ssl
        #containers & VM
        $PACMAN apptainer lxd podman podman-compose podman-docker vagrant
        #CLI text tools
        $PACMAN ack antiword bat dasel fzf gawk glow grep highlight jq miller pandoc ripgrep sed xsv
        #CLI file management
        $PACMAN exa fd lf ncdu ranger
        #CLI process management
        $PACMAN btop
        #printing
        $PACMAN cups cups-filters foomatic-db
        #languages
        $PACMAN aspell aspell-de aspell-en aspell-es aspell-fr aspell-it aspell-nl aspell-ru hunspell
        #TeX
        $PACMAN texlive-bibtexextra texlive-bin texlive-core texlive-fontsextra texlive-formatsextra texlive-humanities texlive-langextra texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science
        #plotting
        $PACMAN gnuplot graphviz
        #various
        $PACMAN amfora lynx links w3m urlscan chafa
        #compression
        $PACMAN p7zip unrar xz zstd

        if [ -z "$NO_DESKTOP" ]; then
            #desktop: wayland core
            $PACMAN bemenu foot grim hyprland i3status imv libpipewire02 mako mesa slurp swaybg swayidle swaylock wev wl-clipboard wofi wtype xdg-desktop-portal-wlr xorg-xwayland ydotool
            #desktop: basic
            $PACMAN bemenu-wayland chromium firefox gedit network-manager-applet pcmanfm rofi telegram-desktop thunar zathura zathura-pdf-poppler
            #fonts
            $PACMAN noto-fonts-emoji otf-fira-mono ttf-dejavu ttf-droid ttf-fira-code ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-font-awesome ttf-khmer ttf-linux-libertine ttf-opensans ttf-roboto ttf-tibetan-machine ttf-ubuntu-font-family wqy-bitmapfont wqy-microhei wqy-zenhei
            #graphics & video
            $PACMAN cheese feh ffmpeg gimp imagemagick imv inkscape mplayer mpv sxiv v4l-utils vlc yt-dlp
            #IME & languages
            $PACMAN fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt
            #various
            $PACMAN calibre
            #containers & vm
            $PACMAN flatpak virtualbox
        fi

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
            if ! command -v yay; then
                echo "Installing yay"
                d=$(pwd)
                cd /tmp/
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si
                cd "$d"
            fi
            yay -S waybar-hyprland-git lf-sixel-git lsix-git otf-nerd-fonts-fira-mono powerline-fonts-git ttf-material-design-icons-git ttf-symbola ccls ttf-nerd-fonts-input || echo "WARNING: yay is not installed yet, do so yourself!">&2
        fi
    elif [ "$OS" = "postmarketos" ]; then
        sudo apk update
        sudo apk upgrade
        sudo apk add bash bat espeak feh font-fira-code font-fira-mono-nerd freetype-dev fzf gcc git htop lf libc-dev libx11-dev libxcb-dev libxft-dev libxinerama-dev libxtst-dev linux-headers make mpc mpv ncdu newsboat openssh python3 sxiv tig tmux tuir vim weechat wqy-zenhei zathura-pdf-mupdf zsh || exit 2
    else
        echo "Distribution not supported!">&2
        sleep 10
    fi
fi

cd ~
HOMEDIR=$(pwd)
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
