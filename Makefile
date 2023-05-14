# -- config variables you can adapt on the command line
DESKTOP := 1


# -- automatically computed or static parameters
DISTRO := $(shell . /etc/os-release; echo $$ID)
PACMAN := sudo pacman -S --needed
APK := sudo apk add
APT := sudo apt-get install


.PHONY: targets packages install aur yay update updating


targets: target/config/Makefile target/home/Makefile

target/home:
	mkdir -p target
	ln -sf ~ target/home

target/config:
	mkdir -p target
	mkdir -p ~/.config
	ln -sf ~/.config target/.config

target/config/Makefile: target/config
	ln -sf ~/dotfiles/Makefile.config target/.config/Makefile

target/home/Makefile: target/home
	ln -sf ~/dotfiles/Makefile.home target/home/Makefile

links: targets 
	make -C ~/.config/
	make -C ~
	~/dotfiles/scripts/darkmode.sh

packages:
	@echo "--> Installing packages"
ifeq ($(DISTRO),arch)
	#sync once
	sudo pacman -Sy
	#core
	${PACMAN} base-devel bash busybox bzip2 coreutils e2fsprogs fzf gnupg gnutls gzip hdparm htop iotop iperf less lm_sensors lsb-release lshw lsof make nano neovim openssh openssl procps-ng psmisc readline rsync sudo tar time tmux tree udiskie vi zip zsh pass apparmor firejail man tldr
	#networking
	${PACMAN} curl fping inetutils netcat networkmanager nfs-utils nm-connection-editor nmap nmap smbclient sshfs traceroute usbutils wget whois wireshark-cli termshark openfortivpn gocryptfs
	#version control
	${PACMAN} git mercurial subversion tig hut github-cli
	#audio
	${PACMAN} alsa-firmware alsa-ucm-conf audacity gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer mpc ncmpcpp pamixer pavucontrol pipewire-alsa pipewire-pulse sof-firmware
	#dev: python
	${PACMAN} ipython jupyter-nbconvert jupyter-notebook jupyterlab python python-cherrypy python-django python-flask python-jinja python-jupyter-client python-jupyter-core python-lxml python-matplotlib python-numpy python-oauth2client python-oauthlib python-pandas python-pillow python-pip python-psutil python-requests python-scikit-learn python-scipy python-seaborn python-setuptools python-setuptools python-sphinx python-virtualenv python-yaml
	#dev: rust
	${PACMAN} cargo go nodejs npm rust rust-src
	#dev: C/C++
	${PACMAN} autoconf autoconf-archive automake cmake ctags doxygen gdb gmp icu m4 meson ninja pkg-config valgrind libxml2
	#dev: various programming languages
	${PACMAN} go groovy jdk-openjdk lua maven nodejs perl ruby
	#dev: distro specific
	${PACMAN} apk-tools debootstrap pmbootstrap android-tools
	#(abuild is in AUR)
	#dev: linters, formatters
	${PACMAN} bash-language-server lua-language-server ccls cppcheck eslint flake8 prettier pyright python-pylint rustfmt shellcheck
	#communication
	${PACMAN} aerc mailcap mosquitto msmtp-mta newsboat weechat notmuch
	#libs
	${PACMAN} perl-mime-tools perl-net-smtp-ssl
	#containers & VM
	${PACMAN} apptainer lxd podman buildah podman-compose podman-docker vagrant kubectl
	#CLI text tools
	${PACMAN} ack antiword bat fmt fzf gawk glow grep highlight jq miller pandoc ripgrep sed xsv
	#CLI file management
	${PACMAN} exa fd ncdu
	#(lf will be installed from AUR)
	#CLI process management
	${PACMAN} btop
	#printing
	${PACMAN} cups cups-filters foomatic-db
	#languages
	${PACMAN} aspell aspell-de aspell-en aspell-es aspell-fr aspell-it aspell-nl aspell-ru hunspell
	#TeX
	${PACMAN} texlive-bibtexextra texlive-bin texlive-core texlive-fontsextra texlive-formatsextra texlive-humanities texlive-langextra texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science
	#plotting
	${PACMAN} gnuplot graphviz plantuml
	#various
	${PACMAN} amfora lynx links w3m urlscan chafa semver oath-toolkit pwgen
	#compression
	${PACMAN} p7zip unrar xz zstd
ifeq ($(DESKTOP),1)
	#desktop: wayland core
	${PACMAN} bemenu foot grim hyprland i3status imv libpipewire mako mesa slurp swaybg swayidle swaylock wofi wtype xdg-desktop-portal-hyprland xorg-xwayland ydotool
	#desktop: basic
	${PACMAN} bemenu-wayland chromium element-desktop firefox gedit gnome-keyring libreoffice-fresh network-manager-applet pcmanfm telegram-desktop thunar xdg-utils zathura zathura-pdf-poppler
	#(rofi will be installed from AUR)
	#fonts
	${PACMAN} noto-fonts-emoji otf-fira-mono ttf-dejavu ttf-droid ttf-fira-code ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-font-awesome ttf-khmer ttf-linux-libertine ttf-opensans ttf-roboto ttf-tibetan-machine ttf-ubuntu-font-family wqy-bitmapfont wqy-microhei wqy-zenhei cantarell-fonts gucharmap
	#graphics & video
	${PACMAN} cheese feh ffmpeg gimp imagemagick imv inkscape mplayer mpv sxiv v4l-utils vlc yt-dlp kdenlive ytfzf
	#IME & languages
	${PACMAN} fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-configtool ibus-libpinyin
	#various
	${PACMAN} calibre zola hugo
	#containers & vm
	${PACMAN} flatpak virtualbox
	@echo "--> Run make aur manually to also make aur packages !!!"
endif
else ifeq ($(DISTRO),$(filter $(DISTRO), alpine postmarketos))
	sudo apk update
	sudo apk upgrade
	${APK} bash bat espeak feh font-fira-code font-fira-mono-nerd freetype-dev fzf gcc git htop lf libc-dev libx11-dev libxcb-dev libxft-dev libxinerama-dev libxtst-dev linux-headers make mpc mpv ncdu newsboat openssh python3 sxiv tig tmux tuir vim weechat wqy-zenhei zathura-pdf-mupdf zsh
else ifeq ($(DISTRO),$(filter $(DISTRO), debian ubuntu))
	sudo apt-get update
	${APT} ack aptitude autoconf-archive bat chafa curl fping gawk gcc git glances highlight htop iotop jq ncdu neovim netcat pandoc sed tig tmux wget whiptail zsh
else
	$(error "Unknown distribution")
endif

yay:
ifeq ($(DISTRO),arch)
ifeq (, $(shell which yay))
	@echo "--> Installing yay"
	{ \
		git clone https://aur.archlinux.org/yay.git && \
		cd yay && \
		makepkg -si && \
		sudo pacman -U yay*zst
	}
endif
endif 

aur: yay abuild aercbook-bin dasel gomuks-git lf-sixel-git lsix-git mblaze-git nerd-fonts-meta powerline-fonts-git rofi-lbonn-wayland telegram-tg-git todotxt ttf-material-design-icons-git ttf-symbola waybar-hyprland-git

.PHONY: abuild aercbook-bin dasel gomuks-git lf-sixel-git lsix-git mblaze-git nerd-fonts-meta powerline-fonts-git rofi-lbonn-wayland telegram-tg-git todotxt ttf-material-design-icons-git ttf-symbola waybar-hyprland-git
abuild aercbook-bin dasel gomuks-git lf-sixel-git lsix-git mblaze-git nerd-fonts-meta powerline-fonts-git rofi-lbonn-wayland telegram-tg-git todotxt ttf-material-design-icons-git ttf-symbola waybar-hyprland-git:
ifeq ($(DISTRO),arch)
	yay -S $@
endif

install: packages links

update:
	git pull --recurse-submodules=yes
	make updating

updating: install
	make -C ~/.config/ update
	make -C ~ update

all: install
