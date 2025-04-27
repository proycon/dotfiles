#export XDG_CONFIG_HOME="/home/proycon/.config" Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
[ -z "$ZSH_THEME" ] && ZSH_THEME="proysh"

# ZSH_THEME is not used anymore when starship is enabled!!

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

unset CHECKGIT
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(ansible archlinux debian git git-flow github tig history history-substring-search lxd pip python pylint rust systemd ufw vi-mode zsh-autosuggestions pass podman qrcode rsync kubectl zsh-interactive-cd starship copybuffer)

source $ZSH/oh-my-zsh.sh

setopt cshnullglob
unsetopt correct_all
unset GREP_OPTIONS #deprecated
if [ "$OSTYPE" = "linux-musl" ]; then
    unalias grep 2>/dev/null
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
alias gca="git commit -a"
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
alias yz=yazi
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
alias xl='translate.sh'
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

export TODO_DIR="$HOME/.todo"


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


if command -v exa > /dev/null 2>/dev/null; then
    alias l='exa'
    alias ll='exa -l'
else
    alias l='ls'
    alias ll='ls -l'
fi
if command -v bat > /dev/null 2>/dev/null; then
    export PAGER="bat --style=plain --paging=always"
    export BAT_PAGER="less -q"
else
    export PAGER="less"
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


alias -s txt=vim
alias -s cpp=vim
alias -s cxx=vim
alias -s h=vim
alias -s tex=vim
alias -s bib=vim
alias -s js=vim
alias -s css=vim
alias -s rs=vim
alias -s csv=tw
alias -s tsv=tw --seperator "	"

alias -s pdf=zathura
alias -s webm=imv
alias -s jpg=imv
alias -s png=imv
alias -s eps=imv
alias -s gif=imv
alias -s mp3=mpv
alias -s ogg=mpv

alias -s html=firefox

function s() {
    clear
    for i in $(seq 0 20); do
        echo "\n"
    done
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}(${VIRTUAL_ENV:t})${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

function rmd () {
  pandoc -s -f gfm -H ~/dotfiles/header.sty -o /tmp/rmd.pdf $1
  zathura /tmp/rmd.pdf
}

export VIRTUAL_ENV_DISABLE_PROMPT=1


export PINENTRY_USER_DATA=curses
source ~/dotfiles/scripts/gpgsetup.sh

export NNN_FIFO="/tmp/nnn.fifo"
export NNN_PLUG="o:fzopen;c:fcd;j:jump;p:preview-tui;i:imgview;d:dragdrop"
export BAT_THEME="gruvbox-dark"
alias nnn="nnn -e"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#706060"  

PANEL_FIFO=/tmp/panel-fifo
PANEL_HEIGHT=24
PANEL_FONT_FAMILY="-*-terminus-medium-r-normal-*-12-*-*-*-c-*-*-1"
export PANEL_FIFO PANEL_HEIGHT PANEL_FONT_FAMILY

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
#bindkey '\e[1' beginning-of-line
#bindkey '\e[4' end-of-line
#bindkey '\e[[1' beginning-of-line
#bindkey '\e[[4' end-of-line
#bindkey '\e[A' history-substring-search-up
#bindkey '\e[B' history-substring-search-down
#bindkey '^H' history-substring-search-up
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
#bindkey '[C' forward-word
#bindkey '[D' backward-word

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

[ -f ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.local/bin:$PATH"
unset LESS_TERMCAP_so

if [ "$(tty)" = "/dev/tty1" ]; then
    command -v river && exec ~/dotfiles/scripts/startriver.sh
fi
