# -- config variables you can adapt on the command line
DESKTOP := 1
FULLDESKTOP := 0 #only for alpine/pmos, distinguishes from phone



# -- automatically computed or static parameters
DISTRO := $(shell . /etc/os-release; echo $$ID)
PACMAN := sudo pacman -S --needed
APK := sudo apk add --no-interactive
APT := sudo apt-get install


.PHONY: targets packages install aur yay update updating


targets: target/config/Makefile target/home/Makefile target/home/bin

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

target/home/bin:
	mkdir target/home/bin

links: targets 
	make -C ~/.config/ all
	make -C ~ all
	~/dotfiles/scripts/darkmode.sh || true

packages:
	@echo "--> Installing packages"
ifeq ($(DISTRO),arch)
	#sync once
	sudo pacman -Sy
	#core
	${PACMAN} base-devel bash busybox bzip2 coreutils e2fsprogs fzf gnupg gnutls gzip hdparm htop iotop iperf less lm_sensors lsb-release lshw lsof make nano neovim openssh openssl procps-ng psmisc readline rsync rclone sudo tar time tmux tree udiskie vi zip zsh pass apparmor firejail man tldr tailspin
	#networking
	${PACMAN} curl fping inetutils netcat networkmanager nfs-utils nm-connection-editor nmap nmap smbclient sshfs traceroute usbutils wget whois wireshark-cli termshark openfortivpn gocryptfs
	#version control
	${PACMAN} git mercurial subversion tig hut github-cli
	#audio
	${PACMAN} alsa-firmware alsa-ucm-conf audacity gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer mpc ncmpcpp pamixer pavucontrol pipewire-alsa pipewire-pulse sof-firmware
	#dev: python
	${PACMAN} ipython jupyter-nbconvert jupyter-notebook jupyterlab python python-cherrypy python-django python-flask python-jinja python-jupyter-client python-jupyter-core python-lxml python-matplotlib python-numpy python-oauth2client python-oauthlib python-pandas python-pillow python-pip python-psutil python-requests python-scikit-learn python-scipy python-seaborn python-setuptools python-setuptools python-sphinx python-virtualenv python-yaml twine
	#dev: rust
	${PACMAN} cargo rust rust-src
	#dev: C/C++
	${PACMAN} autoconf autoconf-archive automake cmake ctags doxygen gdb gmp icu m4 meson ninja pkg-config valgrind libxml2
	#dev: various programming languages
	${PACMAN} go groovy jdk-openjdk lua maven nodejs nodejs npm perl ruby
	#dev: distro specific
	${PACMAN} apk-tools debootstrap pmbootstrap android-tools
	#(abuild is in AUR)
	#dev: linters, formatters, misc
	${PACMAN} bash-language-server lua-language-server ccls cppcheck eslint flake8 prettier openapi-tui pyright python-pylint rustfmt shellcheck tokei hyperfine
	#communication
	${PACMAN} aerc mailcap mosquitto msmtp-mta newsboat weechat notmuch senpai
	#libs
	${PACMAN} perl-mime-tools perl-net-smtp-ssl
	#containers & VM
	${PACMAN} apptainer lxd podman buildah podman-compose podman-docker vagrant kubectl
	#CLI text tools
	${PACMAN} ack antiword bat difftastic fmt fzf gawk glow grep highlight jless jq miller pandoc ripgrep sed tabiew xsv
	#CLI file management
	${PACMAN} exa fd ncdu lf yazi
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
	#hardware key
	${PACMAN} python-pynitrokey libnitrokey
	#desktop: wayland core
	${PACMAN} bemenu foot grim river waylock waybar kanshi i3status imv libpipewire mako mesa slurp swaybg swayidle wofi wtype xdg-desktop-portal-wlr xorg-xwayland ydotool catimg wl-clipboard
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
	#core
	${APK} build-base bash fzf gnupg htop lm_sensors lshw neovim openssh openssl readline starship sudo tmux tree zip zsh pass docs rsync rclone
	#vcs
	${APK} git tig github-cli hut
	#networking
	${APK} curl nmap sshfs mosquitto-clients vnstat termshark bmon
	#dev: C/C++
	${APK} autoconf autoconf-archive automake cmake ctags doxygen gdb gmp icu m4 meson ninja libxml2
	${APK} shellcheck tokei hyperfine
	${APK} zola
	#CLI text tools
	${APK} ack bat fmt highlight dasel delta jless jq miller pandoc ripgrep sed xsv mdcat
	#CLI file management
	${APK} exa fd ncdu yazi yazi-cli
	#python
	${APK} python3 py3-pip py3-wheel py3-setuptools py3-pylint py3-numpy py3-scipy py3-lxml py3-virtualenv jupyter-notebook py3-matplotlib
	#various:
	${APK} btop gnuplot todo.txt-cli todo.txt-cli amfora w3m lynx links urlscan tailspin tldr-python-client oath-toolkit pwgen vocage
	#languages
	${APK} aspell aspell-en aspell-es aspell-fr aspell-de
	#communication
	${APK} aerc mailcap msmtp newsboat newsraft
ifeq ($(DESKTOP),1)
	#core desktop
	${APK} bemenu rofi-wayland foot mako kanshi river river-bedload rivercarro swaybg swayidle waybar waylock peanutbutter wofi wtype xdg-desktop-portal-wlr catimg wl-clipboard libnotify py3-pynitrokey libnitrokey udiskie
	#icons & themes
	${APK} breeze-icons 
	#containers
	${APK} cargo go nodejs npm
	#browser
	${APK} firefox
	#IME & languages
	${APK} fcitx5 fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-configtool
	#multimedia
	${APK} mpv mpc espeak sxiv imv yt-dlp ncmpcpp lf chafa grim slurp ffmpeg ytfzf
	#fonts
	${APK} font-fira-mono-nerd font-ubuntu-nerd font-wqy-zenhei font-noto-all font-cantarell font-awesome font-ubuntu font-droid font-material-icons
	#communication
	${APK} nheko telegram-desktop buku fractal iamb
	#various
	${APK} zathura evince geary flawz
ifeq ($(FULLDESKTOP),1)
	#things that go only on a desktop/laptop and not on a phone
	#multimedia
	${APK} gimp inkscape krita calibre kdenlive obs-studio
	#containers
	${APK} podman podman-compose podman-zsh-completion flatpak
	#libreoffice
	${APK} libreoffice
	#various
	${APK} element-desktop cheese chromium plantuml
	#printer
	${APK} cups cups-filters
	#LaTeX
	${APK} texlive texlive-full texmf-dist-humanities
endif
endif
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

aur: yay abuild aercbook-bin dasel gomuks-git lsix-git mblaze-git nerd-fonts-complete-starship powerline-fonts-git rofi-lbonn-wayland todotxt ttf-material-design-icons-git ttf-symbola snapcast-git crates-tui pass-git-helper lswt newsraft

.PHONY: abuild aercbook-bin dasel gomuks-git lsix-git mblaze-git nerd-fonts-complete-starship powerline-fonts-git rofi-lbonn-wayland todotxt ttf-material-design-icons-git ttf-symbola snapcast-git crates-tui pass-git-helper lswt newsraft
abuild aercbook-bin dasel gomuks-git lsix-git mblaze-git nerd-fonts-complete-starship powerline-fonts-git rofi-lbonn-wayland todotxt ttf-material-design-icons-git ttf-symbola snapcast-git crates-tui pass-git-helper lswt newsraft:
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
