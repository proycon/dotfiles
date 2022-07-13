#export XDG_CONFIG_HOME="/home/proycon/.config" Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="proysh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

unset CHECKGIT
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(vi-mode history history-substring-search git python debian pip github git-flow rust ripgrep fd lxd rust ufw zsh-autosuggestions ansible systemd archlinux)

source $ZSH/oh-my-zsh.sh

setopt cshnullglob
unsetopt correct_all
unset GREP_OPTIONS #deprecated



#apps
menu () {
    whiptail --menu "Menu" 25 80 15 sysadmin "Sysadmin tools" file "File management" data "Data tools" tldr "tldr" cheat "cheat"  2> ~/.menuchoice
    choice=$(cat ~/.menuchoice)
    if [[ "$choice " == "sysadmin"* ]]; then
        whiptail --menu "Menu" 25 80 15 atop "Apache top (root)" bmon "Bandwidth Monitor" btop "Interactive process viewer" glances "Interactive process viewer" htop "Interactive process viewer" iftop "Network interface monitoring" iostat "I/O Statistics" iotop "I/O monitor (root)" lshw "List hardware" lsmod "List kernel modules" lsof "List open files" lspci "List PCI devices" lsusb "List USB devices" netcat "Read/write network data" netstat "Print network connections" top "Interactive process viewer" vmstat "Report virtual memory statistics" wavemon "Wireless monitor" 2> ~/.menuchoice
        eval $(cat ~/.menuchoice)
    elif [[ "$choice " == "file"* ]]; then
        whiptail --menu "Menu" 25 80 15 ranger "ranger: Terminal file manager" br "Broot Tree Navigation" lf "lf: Terminal file manager"  2> ~/.menuchoice
    elif [[ "$choice " == "data"* ]]; then
        whiptail --menu "Menu" 25 80 15 ack "Grep-like text finder" bat "Fancy cat viewer" glow "Fancy markdown viewer" fd "Find replacement" jq "JSON-processor" rg "Ripgrep" vd "Tabular data viewer" xsv "CSV processor" 2> ~/.menuchoice
    else
        eval $(cat ~/.menuchoice)
    fi
}
alias en='LANGUAGE="en_US.UTF-8" zsh'
alias km="setxkbmap proylatin"
alias mk='LANGUAGE="en_GB.UTF-8" make'
alias mi='LANGUAGE="en_GB.UTF-8" make install; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Sys-App-Positive.ogg 2> /dev/null &!; else; play -q /usr/share/sounds/KDE-K3B-Finish-Error.ogg 2> /dev/null &!; fi; hr'
alias glmi='sshcheck && git pull &&  && git submodule update && LANGUAGE="en_GB.UTF-8" make install; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Sys-App-Positive.ogg 2> /dev/null &!; else; play -q /usr/share/sounds/KDE-K3B-Finish-Error.ogg 2> /dev/null &!; fi; hr'
alias glsi='git pull && git submodule update && pip install .'
alias psi='pip install .'
alias pi='pip install .'
alias gl='sshcheck && git pull && git submodule update; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Minimize.ogg 2> /dev/null &!; fi'
alias gp='sshcheck && git push; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Maximize.ogg 2> /dev/null &!; fi'
alias pg='git push; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Maximize.ogg 2> /dev/null &!; fi'
alias gca="LD_LIBRARY_PATH= git commit -a"
alias cf='LANGUAGE="en_GB.UTF-8" ./configure'
alias pm="podman"
alias pmc="podman-compose"
alias a='tmux attach'
alias b="buku"
alias tmux='tmux -2' #force 256 colour support regardless of terminal
alias ta='~/todo.sh add'
alias ka='killall'
alias za='zathura'
alias sx='sxiv -t .'
alias gpp='git push origin gh-pages'
alias mp="ncmpcpp -b ~/dotfiles/ncmpcpp.bindings"
alias f='cd $(cat ${XDG_CONFIG_HOME:-$HOME/.config}/directories | fzf)'
alias hs="~/dotfiles/homestatus.sh"
alias ghils="gh issue list"
alias ghls="gh issue list"
alias ghic="gh issue create"
alias ghiv="gh issue view"
alias ghicm="gh issue comment"
alias protontricks-flat="flatpak run com.github.Matoking.protontricks"
alias hutsxmo="hut lists patchset list \~mil/sxmo-devel"
alias hutsxmo2="hut todo ticket list -t \~mil/sxmo-tickets"
alias lh="linkhandler"
lh0() {
    rm /tmp/linkhandler.target 2> /dev/null || echo "(already set)"
}
lh1() {
    echo -n "1" > /tmp/linkhandler.target
}
lh2() {
    echo -n "2" > /tmp/linkhandler.target
}
if [ ! -z "$DISPLAY" ]; then
    alias lf="~/dotfiles/lf/lfrun" #wrapper for ueberzug support
fi
#colours
#which colorgcc > /dev/null 2> /dev/null
#if (( $? == 0 )); then
#    export CC="colorgcc"
#fi
alias z='less -rN'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
if [[ "$HOST" == "proyphone" ]]; then
    alias vi="vis"
    alias vim="vis"
else
    if which nvim > /dev/null 2> /dev/null; then
        export EDITOR="nvim"
        alias vi="LD_LIBRARY_PATH= nvim"
        alias vim="LD_LIBRARY_PATH= nvim"
    else
        if which vim > /dev/null 2>/dev/null; then
            export EDITOR="vim"
            alias vi="vim"
        fi
    fi
fi


export MPD_HOST="anaproy.nl"

export DEBEMAIL="proycon@anaproy.nl"
export DEBFULLNAME="Maarten van Gompel"

export BROWSER="firefox"

export XDG_CONFIG_HOME="$HOME/.config"


#coloured man pages
export GROFF_NO_SGR=1
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m'   \
    LESS_TERMCAP_md=$'\E[01;38;5;74m'  \
    LESS_TERMCAP_me=$'\E[0m'           \
    LESS_TERMCAP_se=$'\E[0m'           \
    LESS_TERMCAP_so=$'\E[30;42m'       \
    LESS_TERMCAP_ue=$'\E[0m'           \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}


tlms() {
    tmux list-windows -a -F "#S.#I: #W (#{window_panes}) -- #{pane_current_command} @ #{pane_current_path} -- #{t:window_activity} #{?window_activity_flag,(changed),} #{?window_active,(active),} " | while read line; do if [[ $line =~ "(changed)" ]]; then clr='\e[1;31m'; elif [[ $line =~ "(active)" ]]; then clr='\e[0;32m'; else clr='\e[0;37m'; fi; echo -e $clr "  " "$line"; done
}

topcommands() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n $1
}

alias dis='export $(tmux showenv | grep DISPLAY)'

if [ -f ~/bin/lamachine-main-activate ]; then
    alias lm='source ~/bin/lamachine-main-activate'
elif [ -f ~/bin/lamachine-stable-activate ]; then
    alias lm='source ~/bin/lamachine-stable-activate'
fi
if [ -f ~/bin/lamachine-dev-activate ]; then
    alias lmdev='source ~/bin/lamachine-dev-activate'
fi


#PATHS
if [[ $HOST == "rocinante" || $HOST == "mhysa" || $HOST == "drasha" ]]; then
    export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:$PATH"
    #export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/proycon/local/lib"
    export CDPATH=.:~/work:~/projects
    #export PYTHONPATH="/home/proycon/work/"
    #export ANDROID_SDK="/usr/local/android-sdk-linux"

    hash -d X=/home/proycon/exp
    #hash -d lsrc=/home/proycon/local/src/
    hash -d W=/home/proycon/work
    hash -d P=/home/proycon/projects
elif [[ $HOST == "proyphone" ]]; then
    export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:$PATH"

elif [[ $HOST == "applejack" || $HOST == "fluttershy" || $HOST == "rarity" || $HOST == "cheerilee" || $HOST == "fancypants" || $HOST == "pipsqueak" || $HOST == "scootaloo" || $HOST == "blossomforth" || $HOST == "featherweight" || $HOST == "twist" || $HOST == "thunderlane" || ${HOST:0:3} == "mlp" ]]; then
    alias lmws='source lamachine-weblamachine-activate'
    alias lmws1='source /var/www/lamachine/bin/activate'
    alias lm='source /vol/customopt/bin/lamachine-activate'
    alias lmdev='source /vol/customopt/bin/lamachine-dev-activate'
    #export LD_LIBRARY_PATH="/vol/customopt/machine-translation/lib:/vol/customopt/nlptools/lib/:$LD_LIBRARY_PATH"
    BASEPATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:/vol/customopt/machine-translation/bin:$PATH"
    #/vol/customopt/uvt-ru/bin:/vol/customopt/alpino/bin:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/nlptools/bin/:/vol/customopt/nlptools/cmd/:/vol/customopt/cython3/bin/:$PATH"
    export PATH=$BASEPATH
    export CDPATH=.:/scratch/proycon/:/scratch/proycon/local/:/scratch/proycon/local/src/
    #export PYTHONPATH="/home/proycon/:/vol/customopt/uvt-ru/lib/python2.7/site-packages/:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/uvt-ru/lib/python2.7/site-packages/frog/:/vol/customopt/nlptools/stanford-corenlp-python:/vol/customopt/uvt-ru/lib/python3.2/site-packages/:/vol/customopt/python3-packages/lib/python3.2/site-packages/"
    #export CLASSPATH="/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4.jar:/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4-models.jar:/vol/customopt/nlptools/stanford-corenlp-full/xom.jar:/vol/customopt/nlptools/stanford-corenlp-full/joda-time.jar:/vol/customopt/nlptools/stanford-corenlp-full/jollyday.jar:/vol/customopt/nlptools/javalib:."
    #export FREELINGSHARE="/vol/customopt/nlptools/share/freeling/"
    if [ -d /scratch/proycon/tmp ]; then
        export TMPDIR="/scratch/proycon/tmp"
    fi
    hash -d X=/scratch/proycon/
    hash -d corpora=/vol/bigdata/corpora/
    hash -d lm=/vol/customopt/lamachine/
    hash -d lmdev=/vol/customopt/lamachine.dev/
    hash -d lmsrc=/vol/customopt/lamachine/src/
    hash -d mt=/vol/customopt/machine-translation/
    hash -d corp=/vol/bigdata/corpora/
    hash -d bd=/vol/bigdata/users/proycon/
    hash -d tu=/vol/tensusers/proycon/
    hash -d ws=/var/www/webservices-lst/live

    umask u=rwx,g=rx,o=rx
else
    DOMAIN=$(hostname -d | tr -d "\n")
    if [[ $DOMAIN == "anaproy.lxd" || $HOST == "anaproy" || $HOST == "anaproy2" ]]; then
        export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:$PATH"
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/proycon/local/lib"
        export PYTHONPATH="/home/proycon/work/"
        export CDPATH=.:~/work:~/projects

        hash -d X=/home/proycon/exp
        hash -d lsrc=/home/proycon/local/src/
        hash -d W=/home/proycon/work
        hash -d P=/home/proycon/projects
    fi
fi


#if [[ -f  /usr/share/source-highlight/src-hilite-lesspipe.sh ]]; then
#    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
#fi

which exa > /dev/null 2>/dev/null
if (( $? == 0 )); then
    alias l='exa'
    alias ll='exa -l'
else
    alias l='ls'
    alias ll='ls -l'
fi
which bat > /dev/null 2>/dev/null
if (( $? == 0 )); then
    export PAGER="bat --style=plain --paging=always"
    export BAT_PAGER="less -q"
else
    export PAGER="less"
fi


alias ssha='sshcheck && ssh -Y -A anaproy.nl'
alias sshm='sshcheck && ssh -Y -A mhysa.anaproy.nl'
alias aj="ssh -Y -A -t applejack.science.ru.nl /home/proycon/bin/tm"
alias fs="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fluttershy /home/proycon/bin/tm"
alias rr="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t rarity /home/proycon/bin/tm"
alias cl="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t cheerilee /home/proycon/bin/tm"
alias fp="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fancypants /home/proycon/bin/tm"
alias pq="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t pipsqueak /home/proycon/bin/tm"
alias so="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t scootaloo /home/proycon/bin/tm"
alias fw="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t featherweight /home/proycon/bin/tm"
alias bf="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t blossomforth /home/proycon/bin/tm"
alias tl="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t thunderlane /home/proycon/bin/tm"
alias tw="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t twist /home/proycon/bin/tm"
alias mlp1="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp01 /home/proycon/bin/tm"
alias mlp01="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp01 /home/proycon/bin/tm"
alias mlp02="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp02 /home/proycon/bin/tm"
alias mlp03="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp03 /home/proycon/bin/tm"
alias mlp04="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp04 /home/proycon/bin/tm"
alias mlp05="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp05 /home/proycon/bin/tm"
alias mlp06="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp06 /home/proycon/bin/tm"
alias mlp07="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp07 /home/proycon/bin/tm"
alias mlp08="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp08 /home/proycon/bin/tm"
alias mlp09="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp09 /home/proycon/bin/tm"
alias mlp10="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp10 /home/proycon/bin/tm"
alias mlp11="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp11 /home/proycon/bin/tm"
alias mlp12="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp12 /home/proycon/bin/tm"
alias mlp13="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t mlp13 /home/proycon/bin/tm"
alias _aj="sshcheck && ssh -Y -A -t applejack.science.ru.nl zsh"
alias _fs="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fluttershy zsh"
alias _rr="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t rarity zsh"
alias _cl="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t cheerilee zsh"
alias _fp="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fancypants zsh"
alias _pq="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t pipsqueak zsh"
alias _so="ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t scootaloo zsh"
alias _sc="ssh -Y -A -t mvgompel@radium.uvt.nl ssh -Y -A -t scylla zsh"
alias homsar="ssh -Y -A -t homsar.uvt.nl zsh"
alias luon="ssh -Y -A -t maartenvg@void.luon.net"
#alias gpga="killall gpg-agent; gpg-agent --daemon --enable-ssh-support --write-env-file /home/proycon/.gpg-agent-info"
#


alias lq="source ~/.sgesh"

alias wtr="curl http://wttr.in/Eindhoven"
alias wttr="curl http://wttr.in/Eindhoven"
alias weather="curl http://wttr.in/Eindhoven"
alias btc="curl eur.rate.sx/btc@30d"


cheat() {
    curl https://cheat.sh/$1
}
qr() {
    curl -s http://qrenco.de/$1 | cat
}


if [[ $HOST == "applejack" || $HOST == "fluttershy" || $HOST == "rarity" || $HOST == "cheerilee" || $HOST == "fancypants" || $HOST == "pipsqueak" || $HOST == "scootaloo" || $HOST == "blossomforth" || $HOST == "featherweight" || $HOST == "twist" || $HOST == "thunderlane" ]]; then

    ipynb() {
        if [ ! -z "$1" ]; then
            ipy3 notebook --no-browser --port=$1
        else
            ipy3 notebook --no-browser --port=8888
        fi
    }

fi

alias py="python3"
alias py2="python2"
alias py3="python3"
alias ipy="ipython3"
alias ipy2="ipython"
alias ipyq="ipython qtconsole"
alias ipyq3="ipython3 qtconsole"
alias ipynb="ipython3 notebook"

sshtunnel() {
    TARGETHOST=$1
    PORT=$2
    ssh -N -f -L localhost:${PORT}:localhost:${PORT} $TARGETHOST
}

sshcheck() {
    [ -n "$SSH_AUTH_SOCK" ] || ssh-add
    true
}

alias dps="dirpersiststore"

alias -s txt=vim
alias -s cpp=vim
alias -s cxx=vim
alias -s h=vim
alias -s tex=vim
alias -s bib=vim
alias -s js=vim
alias -s css=vim

alias -s pdf=zathura
alias -s jpg=imv
alias -s png=imv
alias -s eps=imv
alias -s gif=imv
alias -s mp3=mpg321
alias -s ogg=play

alias -s html=firefox


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
  DISPLAY=:0.0 zathura /tmp/rmd.pdf
}

export VIRTUAL_ENV_DISABLE_PROMPT=1


#if [[ $TERM == "xterm" ]] && [[ $COLORTERM == "gnome-terminal" ]]; then
#if [[ "$TERM" == "alacritty" || "$TERM" == "xterm-kitty" ]]; then
    #not well enough supported yet
    #export TERM="xterm-256color"
#fi
#fi
export PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")' #tmux-powerline support


export GPGKEY="1A31555C"
#if [ -f "${HOME}/.gpg-agent-info" ]; then
#    . "${HOME}/.gpg-agent-info"
#    export GPG_AGENT_INFO
#    #export SSH_AUTH_SOCK
#fi
GPG_TTY=$(tty)
export GPG_TTY

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 6h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi


export NNN_FIFO="/tmp/nnn.fifo"
export NNN_PLUG="o:fzopen;c:fcd;j:jump;p:preview-tui;i:imgview;d:dragdrop"
export BAT_THEME="gruvbox-dark"
alias nnn="nnn -e"

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

set_cursor() {
    local style
    case $1 in
        reset) style=0;; # The terminal emulator's default
        blink-block) style=1;;
        block) style=2;;
        blink-underline) style=3;;
        underline) style=4;;
        blink-vertical-line) style=5;;
        vertical-line) style=6;;
    esac

    [ $style -ge 0 ] && print -n -- "\e[${style} q"
}

function zle-line-init zle-keymap-select {
    case $KEYMAP in
        vicmd)
          set_cursor block
          echo -ne "\033]12;Red\007"
          ;;
         *)
          set_cursor block
          echo -ne "\033]12;Grey\007"
          ;;
    esac
}
#function zle-line-init zle-keymap-select {
#    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$RPROMPT $EPS1"
#    zle reset-prompt
#}
#

zle -N zle-line-init
zle -N zle-keymap-select
zle-line-init() { echoti smkx 2>/dev/null; }
zle-line-finish() { echoti rmkx 2>/dev/null; }
zle -N zle-line-init
zle -N zle-line-finish
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


export LESS_TERMCAP_so=$'\E[30;42m'

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# BEGIN LAMACHINE MANAGED BLOCK - path
if [[ "$PATH" != *"/home/proycon/bin"* ]]; then
    export PATH=~/bin:$PATH #add ~/bin to $PATH, that is where the activation scripts are
fi
# END LAMACHINE MANAGED BLOCK - path

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH:$HOME/.local/bin"

if [ -e /home/proycon/.config/broot/launcher/bash/br ]; then
    source /home/proycon/.config/broot/launcher/bash/br
fi

# added by travis gem
[ ! -s /home/proycon/.travis/travis.sh ] || source /home/proycon/.travis/travis.sh
