if [ -e /etc/os-release ]; then
    source /etc/os-release
    if [ "$OSTYPE" != "linux-musl" ]; then
        alias grep=grep --color=auto
    fi
fi

#apps
menu () {
    whiptail --menu "Menu" 25 80 15 sysadmin "Sysadmin tools" file "File management" desktop "Desktop" development "Development" net "Network" data "Data tools" security "Security" media "Audio/Video" other "Other" tldr "tldr" cheat "cheat"  2> ~/.menuchoice
    choice=$(cat ~/.menuchoice)
    if [[ "$choice " == "sysadmin"* ]]; then
        whiptail --menu "Menu" 25 80 15 btop "Interactive process viewer" cyme "lsusb alternative" dbus-monitor "DBUS Monitor" htop "Interactive process viewer"  iostat "I/O Statistics" iotop "I/O monitor (root)" lshw "List hardware" lsmod "List kernel modules" lsof "List open files" lspci "List PCI devices" lsusb "List USB devices" netcat "Read/write network data" netstat "Print network connections" pkgtop "Package manager" top "Interactive process viewer" tspin "Tailspin: highlighting for logs" udevadm "Device administration" vmstat "Report virtual memory statistics" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "net"* ]]; then
        whiptail --menu "Menu" 25 80 15 atac "API client (postman-like)" atop "Apache top (root)" bmon "Bandwidth Monitor" curl "CLI for HTTP requests (and more)" iftop "Network interface monitoring"  nc "Netcat: Read/write network data" netscanner "Network/Wireless monitor" netstat "Print network connections" nmap "Port scanner" termshark "TUI for Packet sniffing" wavemon "Wireless monitor" wget "Downloader" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "development"* ]]; then
        whiptail --menu "Menu" 25 80 15 abuild "Alpine Package builder" adb "Android Debug Bridge" crates-tui "Crates.io browser" fastboot "Bootloader bridge" flamegraph "Flamegraph" gdb "GNU Debugger" gh "GitHub CLI" "gh dash" "GitHub Dashboard TUI" hut "SourceHut CLI" hyperfine "Benchmarker" make "GNU Make" mosquitto-sub "MQTT sub client" mosquitto-pub "MQTT pub client" openapi-tui "OpenAPI TUI" pmbootstrap "PostmarketOS bootstrap" podman "Container management" scc "Code counter" tig "TUI for git" tokei "Code counter" twine "PyPI package publishing" zola "Static site generator" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "file"* ]]; then
        whiptail --menu "Menu" 25 80 15 find "Find" fd "Find (alternative)" fdisk "Partioner" fzf "Fuzzy finder" lf "Terminal file manager" ncdu "Disk usage TUI" tree "Tree" rclone "File transfer" rsync "File transfer" yazi "Terminal file manager" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "data"* ]]; then
        whiptail --menu "Menu" 25 80 15 column "Pretty-print columns" ack "Grep-like text finder" bat "Fancy cat viewer" csvlens "CSV pager" diagon "Diagram generator (unicode)" diff "Diff" difft "Difftastic" delta "Fancy diff" glow "Fancy markdown viewer" jless "JSON pager" jq "JSON-processor" jnv "JSON interactive jq" mdcat "Markdown cat" mdless "Markdown less" otree "Otree object viewer (json etc)" pandoc "Document conversion" rg "Ripgrep" tw "Tabiew: view tabular data" vd "Tabular data viewer" mlr "TSV,CSV,JSON processor" xsv "CSV processor" zbarimg "QRcode decoder" pgcli "Postgresql client" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "security"* ]]; then
        whiptail --menu "Menu" 25 80 15 age "File encryption" flawz "CVE browser (TUI)" gpg "GnuPG" gpg-tui "GnuPG TUI" pass "Password manager" pwgen "Password generator" nitropy "NitroKey tool"   2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "media"* ]]; then
        whiptail --menu "Menu" 25 80 15 alsamixer "Mixer TUI" ffmpeg "Media transcoder and more" grim "Screenshots for wayland"  mpc "MPD client" mpv "Media player" pactl "CLI for pulseaudio" pulsemixer "Pulseaudio mixer TUI" yt-dlp "Youtube downloader"    2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "desktop"* ]]; then
        whiptail --menu "Menu" 25 80 15 lswt "List wayland toplevels" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "other"* ]]; then
        whiptail --menu "Menu" 25 80 15 argos-translate "Machine Translation" buku "Bookmark manager" cal "Calendar" figlet "Banner-like" "todo.sh more" "Todo manager" ollama "Local LLM runner" tclock "Clock/timer in terminal (clock-tui)" tmux "Terminal Multiplexer"  numen "Speech Recognition" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    else
        eval $(cat ~/.menuchoice)
    fi
}

resultsound () {
    if [ $1 -eq 0 ]; then
        if [ -f $HOME/dotfiles/media/$2 ]; then
            mpv --really-quiet $HOME/dotfiles/media/$2 2>/dev/null &!
        fi
    else
        if [ -f $HOME/dotfiles/media/$3 ]; then
            mpv --really-quiet $HOME/dotfiles/media/$3 2>/dev/null &!
        fi
    fi
    return $1
}

HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000
HISTDUP=erase

setopt cshnullglob
unsetopt correct_all

setopt append_history         # Allow multiple sessions to append to one Zsh command history.
setopt extended_history       # Show timestamp in history.
setopt hist_expire_dups_first # Expire A duplicate event first when trimming history.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_ignore_all_dups   # Remove older duplicate entries from history.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_ignore_space      # Do not record an Event Starting With A Space.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt share_history          # Share history between different instances of the shell.

setopt auto_cd              # Use cd by typing directory name if it's not a command.
#setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_pushd           # Make cd push the old directory onto the directory stack.
setopt bang_hist            # Treat the '!' character, especially during Expansion.
setopt interactive_comments # Comments even in interactive shells.
setopt multios              # Implicit tees or cats when multiple redirections are attempted.
setopt no_beep              # Don't beep on error.
#setopt prompt_subst         # Substitution of parameters inside the prompt each time the prompt is drawn.
setopt pushd_ignore_dups    # Don't push multiple copies directory onto the directory stack.
setopt pushd_minus          # Swap the meaning of cd +1 and cd -1 to the opposite.

alias ..="cd .."
alias ...="cd ../.."
alias mi='make install; resultsound $? submit.wav boing.wav'
alias glmi='sshcheck && git pull &&  && git submodule update && LANGUAGE="en_GB.UTF-8" make install; resultsound $? submit.wav boing.wav'
alias glsi='git pull && git submodule update && pip install .; resultsound $? submit.wav boing.wav'
alias pi='pip install .; resultsound $? submit.wav boing.wav'
alias cb='cargo build; resultsound $? submit.wav boing.wav'
alias cbr='cargo build --release; resultsound $? submit.wav boing.wav'
alias gl='sshcheck && git pull && git submodule update; resultsound $? wipe.wav boing.wav'
alias glgh='sshcheck && git pull github $(git branch --show-current) && git submodule update; resultsound $? wipe.wav boing.wav'
alias glsrht='sshcheck && git pull srht $(git branch --show-current) && git submodule update; resultsound $? wipe.wav boing.wav'
alias glu='sshcheck && git pull upstream $(git branch --show-current) && git submodule update; resultsound $? wipe.wav boing.wav'
alias gf='sshcheck && git fetch -a'
alias gco='git checkout'
alias gp='sshcheck && git push; resultsound $? submit.wav boing.wav'
alias gpgh='sshcheck && git push github $(git branch --show-current); resultsound $? submit.wav boing.wav'
alias gpsrht='sshcheck && git push srht $(git branch --show-current); resultsound $? submit.wav boing.wav'
alias gpcb='sshcheck && git push codeberg $(git branch --show-current); resultsound $? submit.wav boing.wav'
alias gpu='sshcheck && git push upstream $(git branch --show-current); resultsound $? submit.wav boing.wav'
gpa() {
    echo "default: " && gp
    git remote | grep -q github && echo "github: " && gpgh
    git remote | grep -q srht && echo "sourcehut: " && gpsrht
    git remote | grep -q codeberg &&  echo "codeberg: " && gpcb
}
alias gca="git commit -a -v"
alias pm="podman"
alias pmc="podman-compose"
alias a='tmux attach'
alias b="buku"
alias i="img2sixel"
alias tmux='tmux -2' #force 256 colour support regardless of terminal
alias ka='killall'
alias za='zathura'
alias sx='sxiv -t .'
alias gpp='git push origin gh-pages'
alias mp="ncmpcpp -b ~/dotfiles/ncmpcpp.bindings"
alias t="todo.sh more"
alias CD='cd $(cat ${XDG_CONFIG_HOME:-$HOME/.config}/directories | fzf)'
alias hs="~/dotfiles/scripts/homestatus.sh"
alias ttw="tw --separator=\"	\""
alias ghils="gh issue list"
alias ghls="gh issue list"
alias ghic="gh issue create"
alias ghiv="gh issue view"
alias ghicm="gh issue comment"
alias protontricks-flat="flatpak run com.github.Matoking.protontricks"
alias hutsxmo="hut lists patchset list \~mil/sxmo-devel"
alias hutsxmo2="hut todo ticket list -t \~mil/sxmo-tickets"
alias mkenv="[ ! -e env ] && python3 -m venv env; . env/bin/activate"
alias mk.env="[ ! -e .env ] && python3 -m venv .env; . .env/bin/activate"
alias surfdrive="rclone ls surfdrive_knaw:"
alias lh="linkhandler"
alias open="linkhandler"
alias xl='~/dotfiles/scripts/translate.sh'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whatismyip="dig +short myip.opendns.com @resolver1.opendns.com"

if [[ "$HOST" == "proyphone" ]] || [[ "$HOST" == "oneplus-enchilada" ]] || [[ "$HOST" == "google-sargo" ]]; then
    if which vis > /dev/null 2> /dev/null; then
        alias vi="vis"
        alias vim="vis"
    fi
else
    if which nvim > /dev/null 2> /dev/null; then
        export EDITOR="nvim"
        alias vi=nvim
        alias vim=nvim
    else
        if which vim > /dev/null 2>/dev/null; then
            export EDITOR="vim"
            alias vi="vim"
        fi
    fi
fi
export PAGER="less"

hsk() {
    grep "$1" ~/projects/vocadata/zh/hsk*.tsv | cut -f 1-4
}
cedict() {
    grep "$1" ~/Documents/languages/chinese/cedict.txt
}

alias gL=gitlog
alias gB=gitbranches

export MPD_HOST="anaproy.nl"

export DEBEMAIL="proycon@anaproy.nl"
export DEBFULLNAME="Maarten van Gompel"

export BROWSER="firefox"

export XDG_CONFIG_HOME="$HOME/.config"
. ~/dotfiles/user-dirs.dirs
export XDG_DESKTOP_DIR XDG_DOCUMENTS_DIR XDG_PICTURES_DIR XDG_MUSIC_DIR XDG_DOWNLOAD_DIR XDG_VIDEOS_DIR

export TODO_DIR="$HOME/Server/.todo"


#coloured man pages
export GROFF_NO_SGR=1
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m'   \
    LESS_TERMCAP_md=$'\E[01;38;5;74m'  \
    LESS_TERMCAP_me=$'\E[0m'           \
    LESS_TERMCAP_se=$'\E[0m'           \
    LESS_TERMCAP_ue=$'\E[0m'           \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}


tlms() {
    tmux list-windows -a -F "#S.#I: #W (#{window_panes}) -- #{pane_current_command} @ #{pane_current_path} -- #{t:window_activity} #{?window_activity_flag,(changed),} #{?window_active,(active),} " | while read line; do if [[ $line =~ "(changed)" ]]; then clr='\e[1;31m'; elif [[ $line =~ "(active)" ]]; then clr='\e[0;32m'; else clr='\e[0;37m'; fi; echo -e $clr "  " "$line"; done
}

topcommands() {
    if [ -z "$1" ]; then
        n=25
    else
        n=$1
    fi
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n $1
}


#PATHS
case "$HOST" in 
    rocinante|trantor|mhysa|pollux|toren)
        export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:$PATH"
        export CDPATH=.:~/work:~/projects

        hash -d X=/home/proycon/exp
        hash -d exp=/home/proycon/exp
        hash -d W=/home/proycon/work
        hash -d work=/home/proycon/work
        hash -d .=/home/proycon/dotfiles
        hash -d dotfiles=/home/proycon/dotfiles
        hash -d P=/home/proycon/projects
        hash -d projects=/home/proycon/projects
        hash -d p=/home/proycon/Pictures
        hash -d pictures=/home/proycon/Pictures
        hash -d D=/home/proycon/Downloads
        hash -d downloads=/home/proycon/Downloads
        hash -d M=/home/proycon/Music
        hash -d music=/home/proycon/Music
        hash -d S=/home/proycon/Server
        hash -d server=/home/proycon/Server
        hash -d cctv=/home/proycon/Server-scratch/cctv/
        hash -d V=/home/proycon/Videos
        hash -d videos=/home/proycon/videos
        hash -d N=/nettmp
        hash -d nettmp=/nettmp
        hash -d T=/tmp
        hash -d tmp=/tmp

        alias sshp='sshcheck && ssh -A pollux.anaproy.nl'
        ;;
    proyphone|pine64-pinephone|oneplus-enchilada|google-sargo)
        export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:$PATH"
        hash -d .=/home/proycon/dotfiles
        hash -d dotfiles=/home/proycon/dotfiles
        hash -d p=/home/proycon/Pictures
        hash -d pictures=/home/proycon/Pictures
        hash -d D=/home/proycon/Downloads
        hash -d downloads=/home/proycon/Downloads
        hash -d M=/home/proycon/Music
        hash -d music=/home/proycon/Music
        hash -d V=/home/proycon/Videos
        hash -d tmp=/tmp
        hash -d T=/tmp
        hash -d tmp=/tmp
        ;;
    mlp*)
        #export LD_LIBRARY_PATH="/vol/customopt/machine-translation/lib:/vol/customopt/nlptools/lib/:$LD_LIBRARY_PATH"
        BASEPATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:/scratch/proycon/apptainer/bin:/vol/customopt/machine-translation/bin:$PATH"
        #/vol/customopt/uvt-ru/bin:/vol/customopt/alpino/bin:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/nlptools/bin/:/vol/customopt/nlptools/cmd/:/vol/customopt/cython3/bin/:$PATH"
        export APPTAINER_CACHEDIR=/scratch/proycon/apptainer/var/apptainer/cache
        export PATH=$BASEPATH
        export CDPATH=.:/scratch/proycon/:/scratch/proycon/local/:/scratch/proycon/local/src/
        #export PYTHONPATH="/home/proycon/:/vol/customopt/uvt-ru/lib/python2.7/site-packages/:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/uvt-ru/lib/python2.7/site-packages/frog/:/vol/customopt/nlptools/stanford-corenlp-python:/vol/customopt/uvt-ru/lib/python3.2/site-packages/:/vol/customopt/python3-packages/lib/python3.2/site-packages/"
        #export CLASSPATH="/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4.jar:/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4-models.jar:/vol/customopt/nlptools/stanford-corenlp-full/xom.jar:/vol/customopt/nlptools/stanford-corenlp-full/joda-time.jar:/vol/customopt/nlptools/stanford-corenlp-full/jollyday.jar:/vol/customopt/nlptools/javalib:."
        if [ -d /scratch/proycon/tmp ]; then
            export TMPDIR="/scratch/proycon/tmp"
        fi
        hash -d X=/scratch/proycon/
        hash -d .=/home/proycon/dotfiles
        hash -d corpora=/vol/bigdata/corpora/
        hash -d mt=/vol/customopt/machine-translation/
        hash -d corp=/vol/bigdata/corpora/
        hash -d bd=/vol/bigdata/users/proycon/
        hash -d tu=/vol/tensusers/proycon/
        hash -d ws=/var/www/webservices-lst/live

        umask u=rwx,g=rx,o=rx

        alias aj="ssh -Y -A -t applejack /home/proycon/bin/tm"
        alias _aj="ssh -Y -A -t applejack"
        alias fs="ssh -Y -A -t fluttershy /home/proycon/bin/tm"
        alias rr="ssh -Y -A -t rarity /home/proycon/bin/tm"
        alias cl="ssh -Y -A -t cheerilee /home/proycon/bin/tm"
        alias fp="ssh -Y -A -t fancypants /home/proycon/bin/tm"
        alias pq="ssh -Y -A -t pipsqueak /home/proycon/bin/tm"
        alias so="ssh -Y -A -t scootaloo /home/proycon/bin/tm"
        alias fw="ssh -Y -A -t featherweight /home/proycon/bin/tm"
        alias bf="ssh -Y -A -t blossomforth /home/proycon/bin/tm"
        alias tl="ssh -Y -A -t thunderlane /home/proycon/bin/tm"
        alias tw="ssh -Y -A -t twist /home/proycon/bin/tm"
        ;;
    *)
        DOMAIN=$(hostname | tr -d "\n")
        case "$DOMAIN" in
            anaproy|anaproy.lxd|anaproy2)
                export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:$PATH"
                export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/proycon/local/lib"
                export PYTHONPATH="/home/proycon/work/"
                export CDPATH=.:~/work:~/projects

                hash -d X=/home/proycon/exp
                hash -d exp=/home/proycon/exp
                hash -d .=/home/proycon/dotfiles
                hash -d dotfiles=/home/proycon/dotfiles
                hash -d lsrc=/home/proycon/local/src/
                hash -d W=/home/proycon/work
                hash -d work=/home/proycon/work
                hash -d P=/home/proycon/projects
                hash -d projects=/home/proycon/projects
                hash -d p=/home/proycon/Pictures
                hash -d pictures=/home/proycon/Pictures
                hash -d M=/home/proycon/Music
                hash -d music=/home/proycon/Music
                ;;
        esac
        ;;
esac


export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;44;01:ow=31;44;01:st=30;44;01:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"
alias ls="ls --color=auto"
if command -v exa > /dev/null 2>/dev/null; then
    alias l='exa'
    alias ll='exa -l'
else
    alias l='ls --color=auto'
    alias ll='ls -l --color=auto'
fi


alias ssha='sshcheck && ssh -A anaproy.nl'


alias wtr="curl https://v2.wttr.in/Eindhoven"
alias wttr="curl https://v2.wttr.in/Eindhoven"
alias weather="curl https://v2.wttr.in/Eindhoven"
alias btc="curl eur.rate.sx/btc@30d"


cheat() {
    curl https://cheat.sh/$1
}
qr() {
    curl -s http://qrenco.de/$1 | cat
}


sshtunnel() {
    TARGETHOST=$1
    PORT=$2
    ssh -N -f -L localhost:${PORT}:localhost:${PORT} $TARGETHOST
}

sshcheck() {
    if [ -n "$SSH_AUTH_SOCK" ]; then
        ssh-add -l > /dev/null 2> /dev/null || ssh-add
    fi
    true
}


alias -s {txt,log,err,md,adoc,scdoc}=bat
alias -s {cpp,cxx,h,tex,bib,js,css,rs}=vim
alias -s csv=tw
alias -s tsv=tw --seperator "	"

alias -s pdf=zathura
alias -s html=firefox
alias -s git="git clone --recursive"

alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,wav,webm}=mpv
alias -s {jpg,png,gif,jpeg,tif,webp}=imv
alias -s xcf=gimp
alias -s svg=inkscape

export PINENTRY_USER_DATA=curses
source ~/dotfiles/scripts/gpgsetup.sh

export NNN_FIFO="/tmp/nnn.fifo"
export NNN_PLUG="o:fzopen;c:fcd;j:jump;p:preview-tui;i:imgview;d:dragdrop"
export BAT_THEME="gruvbox-dark"
alias nnn="nnn -e"
#export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#706060"  


DEBEMAIL="proycon@anaproy.nl"
DEBFULLNAME="Maarten van Gompel"
export DEBEMAIL DEBFULLNAME

#VIM mode
#bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

export KEYTIMEOUT=1

#bindkey -M viins 'jj' vi-cmd-mode

if [ $TERM != "xterm-kitty" ]; then
    bindkey $terminfo[khome] beginning-of-line
    bindkey $terminfo[kend] end-of-line
fi

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

function catcsv {
    sed 's/,/ ,/g' | column -t -s, "$@"
}

function lesscsv {
    catcsv | less -F -S -X -K
}

function cattsv {
    sed 's/,/ ,/g' | column -t -s $'\t' "$@"
}

function lesstsv {
    cattsv | less -F -S -X -K
}

function f {
    if command -v fd >/dev/null; then
        result=$(fd --color=always | fzf --ansi)
    else
        result=$(find . | fzf)
    fi
    if [ -n "$result" ]; then
        open "$result" "$1" #linkhandler
    fi
}

function D {
    if command -v fd >/dev/null; then
        result=$(fd -t d | fzf)
    else
        result=$(find -type d . | fzf)
    fi
    if [ -n "$result" ]; then
        cd "$result"
    fi
}

alias fe="f edit"

alias body="tail -n +2"
alias header="head -n 1"

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

case $TERM in
    xterm*|rxvt)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
        export PROMPT_COMMAND
        ;;
    screen*|screen)
      TITLE=$(hostname -s)
      PROMPT_COMMAND='/bin/echo -ne "\033k${TITLE}\033\\"'
      export PROMPT_COMMAND
        ;;
esac

#case insensitive completion
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
if [ -f /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh #AUR
    HAVE_FZF_TAB=1
elif [ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
    HAVE_FZF_TAB=1
elif [ -f ~/.zsh-fzf-tab/fzf-tab.plugin.zsh ]; then
    #run make `zsh-fzf-tab` to install this
    source ~/.zsh-fzf-tab/fzf-tab.plugin.zsh
    HAVE_FZF_TAB=1
fi

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
if [ "$HAVE_FZF_TAB" = "1" ]; then
    zstyle ':completion:*' menu no
else
    #zsh's own completion
    zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
    zstyle ':completion:*' expand prefix
    zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
    zstyle ':completion:*' menu select=2
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
    zstyle ':completion:*' file-list all
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' group-name ''
    zmodload zsh/complist
fi
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:7,fg+:2,bg+:8 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'


export PATH="$HOME/.local/bin:$PATH"
unset LESS_TERMCAP_so

if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh)"
fi

if [ "$(tty)" = "/dev/tty1" ] && [ command -v river ]; then
    exec ~/dotfiles/scripts/startriver.sh
elif command -v starship > /dev/null; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    eval "$(starship init zsh)"
else
    PROMPT="$(tput setaf 3)%n@%m$(tput sgr0) $(tput setaf 6)%~$(tput sgr0)$(tput setaf 3)%#$(tput sgr0) "
fi
