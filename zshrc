# Path to your oh-my-zsh configuration.
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
plugins=(vi-mode history history-substring-search git svn python django debian pip github git-flow)

source $ZSH/oh-my-zsh.sh

setopt cshnullglob
unsetopt correct_all
unset GREP_OPTIONS #deprecated



#apps
alias x='wrexp'
alias xh='wrexp history'
alias exp='wrexp'
alias hr="echo '_____________________________________________________________________________________'"
alias en='LANGUAGE="en_US.UTF-8" zsh'
alias km="setxkbmap proylatin"
alias mk='LANGUAGE="en_GB.UTF-8" make'
alias mi='LANGUAGE="en_GB.UTF-8" make install; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Sys-App-Positive.ogg 2> /dev/null &!; else; play -q /usr/share/sounds/KDE-K3B-Finish-Error.ogg 2> /dev/null &!; fi; hr'
alias glmi='git pull && LANGUAGE="en_GB.UTF-8" make install; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Sys-App-Positive.ogg 2> /dev/null &!; else; play -q /usr/share/sounds/KDE-K3B-Finish-Error.ogg 2> /dev/null &!; fi; hr'
alias glsi='git pull && python setup.py install'
alias psi='python setup.py install'
alias gl='git pull; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Minimize.ogg 2> /dev/null &!; fi'
alias gp='git push; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Maximize.ogg 2> /dev/null &!; fi'
alias pg='git push; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Maximize.ogg 2> /dev/null &!; fi'
alias cf='LANGUAGE="en_GB.UTF-8" ./configure'
alias t='~/todo/todo.sh'
alias tls='~/todo/todo.sh ls'
alias tlsw='~/todo/todo.sh ls @work'
alias tlsh='~/todo/todo.sh ls @home'
alias tlsp='~/todo/todo.sh projectview @work'
alias tgl='cd ~/todo && git pull && cd -'
alias tgp='cd ~/todo && ((git commit -a -m "todo update" && git push && cd -) || cd - )'
alias ve='. ~/lamachine/bin/activate'
alias lm='. ~/lamachine/bin/activate'
alias lmws='. /scratch2/www/lamachine/bin/activate'
alias lmdev='. ~/lamachine.dev/bin/activate'
alias ve2='. env2/bin/activate'
alias a='tmux attach'
alias tmux='tmux -2' #force 256 colour support regardless of terminal
alias ta='~/todo.sh add'
alias ka='killall'
alias za='zathura'
alias gpp='git push origin gh-pages'
alias r='ranger'
#colours
#which colorgcc > /dev/null 2> /dev/null
#if (( $? == 0 )); then
#    export CC="colorgcc"
#fi
alias vless='vim -R -u /usr/share/vim/vim72/macros/less.vim'
alias l='ls'
alias z='less -rN'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
which nvim > /dev/null 2>/dev/null
if (( $? == 0 )); then
    if [[ "$TERM" == "screen-256color" ]]; then
        export EDITOR="nvim"
        alias vi="nvim"
        alias vim="nvim"
    else
        export EDITOR="nvim_tmux"
        alias vi="nvim_tmux"
        alias vim="nvim_tmux"
        alias nvim="nvim_tmux"
        alias nvim_tmux="tmux -2u new nvim"
    fi
else
    which vim > /dev/null 2>/dev/null
    if (( $? == 0 )); then
        export EDITOR="vim"
        alias vi="vim"
    fi
fi

export MPD_HOST="proycon@anaproy.nl"

export DEBEMAIL="proycon@anaproy.nl"
export DEBFULLNAME="Maarten van Gompel"


export BROWSER="firefox"

#coloured man pages
export GROFF_NO_SGR=1
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m'   \
    LESS_TERMCAP_md=$'\E[01;38;5;74m'  \
    LESS_TERMCAP_me=$'\E[0m'           \
    LESS_TERMCAP_se=$'\E[0m'           \
    LESS_TERMCAP_so=$'\E[37;45m'       \
    LESS_TERMCAP_ue=$'\E[0m'           \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

alias dis='export $(tmux showenv | grep DISPLAY)'

#PATHS
if [[ $HOST == "galactica" || $HOST == "mhysa" || $HOST == "caprica" || $HOST == "drasha" ]]; then
    export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools:$PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/proycon/local/lib"
    export CDPATH=.:~/work
    export PYTHONPATH="/home/proycon/work/"
    export ALPINO_HOME="/usr/local/Alpino"
    export ANDROID_SDK="/usr/local/android-sdk-linux"

    hash -d X=/home/proycon/exp
    hash -d lsrc=/home/proycon/local/src/
    hash -d clb=/home/proycon/work/colibri/
    hash -d cta=/home/proycon/work/colibrita/
    hash -d W=/home/proycon/work
elif [[ $HOST == "roma" ]]; then
    export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:$PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/proycon/local/lib"
    export PYTHONPATH="/home/proycon/work/"
    export ALPINO_HOME="/usr/local/Alpino"
    export CDPATH=.:~/work

    hash -d X=/home/proycon/exp
    hash -d lsrc=/home/proycon/local/src/
    hash -d clb=/home/proycon/work/colibri/
    hash -d cta=/home/proycon/work/colibrita/
    hash -d W=/home/proycon/work
elif [[ $HOST == "applejack" || $HOST == "fluttershy" || $HOST == "rarity" || $HOST == "cheerilee" || $HOST == "fancypants" || $HOST == "pipsqueak" || $HOST == "scootaloo" || $HOST == "blossomforth" || $HOST == "featherweight" || $HOST == "twist" || $HOST == "thunderlane" ]]; then
    export LD_LIBRARY_PATH="/vol/customopt/machine-translation/lib:/vol/customopt/nlptools/lib/:$LD_LIBRARY_PATH"
    BASEPATH="/home/proycon/bin:/home/proycon/local/bin:/vol/customopt/machine-translation/bin:$PATH"
    #/vol/customopt/uvt-ru/bin:/vol/customopt/alpino/bin:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/nlptools/bin/:/vol/customopt/nlptools/cmd/:/vol/customopt/cython3/bin/:$PATH"
    export PATH=$BASEPATH
    export CDPATH=.:/scratch/proycon/:/scratch/proycon/local/:/scratch/proycon/local/src/
    #export PYTHONPATH="/home/proycon/:/vol/customopt/uvt-ru/lib/python2.7/site-packages/:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/uvt-ru/lib/python2.7/site-packages/frog/:/vol/customopt/nlptools/stanford-corenlp-python:/vol/customopt/uvt-ru/lib/python3.2/site-packages/:/vol/customopt/python3-packages/lib/python3.2/site-packages/"
    export CLASSPATH="/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4.jar:/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4-models.jar:/vol/customopt/nlptools/stanford-corenlp-full/xom.jar:/vol/customopt/nlptools/stanford-corenlp-full/joda-time.jar:/vol/customopt/nlptools/stanford-corenlp-full/jollyday.jar:/vol/customopt/nlptools/javalib:."
    export FREELINGSHARE="/vol/customopt/nlptools/share/freeling/"
    export PARAMSEARCH_DIR="/vol/customopt/uvt-ru/src/paramsearch"
    export ALPINO_HOME="/vol/customopt/alpino/"
    if [ -d /scratch/proycon/tmp ]; then
        export TMPDIR="/scratch/proycon/tmp"
    fi
    hash -d X=/scratch/proycon/
    hash -d lsrc=/scratch/proycon/local/src
    hash -d corpora=/vol/bigdata/corpora/
    hash -d ur=/vol/customopt/uvt-ru/
    hash -d lm=/vol/customopt/lamachine/
    hash -d lm14=/vol/customopt/lamachine14/
    hash -d lmsrc=/vol/customopt/lamachine/src/
    hash -d mt=/vol/customopt/machine-translation/
    hash -d corp=/vol/bigdata/corpora/
    hash -d bd=/vol/bigdata/users/proycon/
    hash -d tu=/vol/tensusers/proycon/
    hash -d ws=/scratch2/www/webservices-lst/live

    alias lm14='. /vol/customopt/lamachine14/bin/activate'
    alias lmt='. /vol/customopt/lamachinetest/bin/activate'

    umask u=rwx,g=rx,o=rx
fi


#if [[ -f  /usr/share/source-highlight/src-hilite-lesspipe.sh ]]; then
#    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
#fi



alias ap='ssh -Y -A -t anaproy.nl /home/proycon/bin/tm'
alias rap='ssh -Y -A -t root@anaproy.nl /home/proycon/bin/tm'
alias ssha='ssh -Y -A anaproy.nl'
alias sshat='ssh -Y -A anaproy.nl /home/proycon/bin/tm'
alias e='ssh -Y -A -t anaproy.nl /home/proycon/bin/tm_vi'
alias m="ssh -Y -A -t anaproy.nl /home/proycon/bin/tm_alot"
alias sshilk='ssh u232231@radium.uvt.nl'
alias lo="lilo=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo3.science.ru.nl zsh"
alias aj="applejack=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl /home/proycon/bin/tm"
alias fs="fluttershy=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fluttershy /home/proycon/bin/tm"
alias rr="rarity=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t rarity /home/proycon/bin/tm"
alias cl="cheerilee=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t cheerilee /home/proycon/bin/tm"
alias fp="fancypants=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fancypants /home/proycon/bin/tm"
alias pq="pipsqueak=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t pipsqueak /home/proycon/bin/tm"
alias so="scootaloo=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t scootaloo /home/proycon/bin/tm"
alias fw="featherweight=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t featherweight /home/proycon/bin/tm"
alias bf="blossomforth=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t blossomforth /home/proycon/bin/tm"
alias tl="thunderlane=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t thunderlane /home/proycon/bin/tm"
alias tw="twist=1 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t twist /home/proycon/bin/tm"
alias _aj="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl zsh"
alias _fs="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fluttershy zsh"
alias _rr="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t rarity zsh"
alias _cl="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t cheerilee zsh"
alias _fp="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t fancypants zsh"
alias _pq="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t pipsqueak zsh"
alias _so="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t scootaloo zsh"
alias _sc="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t mvgompel@radium.uvt.nl ssh -Y -A -t scylla zsh"
alias ct="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t mvgompel@radium.uvt.nl ssh -Y -A -t ceto zsh"
alias rv="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t applejack.science.ru.nl ssh -Y -A -t applejack /home/proycon/bin/tm_vi"
alias homsar="ssh -Y -A -t homsar.uvt.nl zsh"
alias luon="ssh -Y -A -t maartenvg@void.luon.net"
#alias gpga="killall gpg-agent; gpg-agent --daemon --enable-ssh-support --write-env-file /home/proycon/.gpg-agent-info"

alias lq="source ~/.sgesh"


if [[ $HOST == "applejack" || $HOST == "fluttershy" || $HOST == "rarity" || $HOST == "cheerilee" || $HOST == "fancypants" || $HOST == "pipsqueak" || $HOST == "scootaloo" || $HOST == "blossomforth" || $HOST == "featherweight" || $HOST == "twist" || $HOST == "thunderlane" ]]; then
    alias expy2="export PYTHONPATH=/vol/customopt/nlptools/stanford-corenlp-python:/vol/customopt/python2-packages/lib/python2.7/site-packages"
    alias expy3="export PYTHONPATH=/vol/customopt/nlptools/stanford-corenlp-python:/vol/customopt/python3-packages/lib/python3.4/site-packages/ PATH=/vol/customopt/python3-packages/bin:$BASEPATH"



    ipynb() {
        expy3
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
    ssh -N -f -L localhost:${2}:localhost:${2} $1
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

alias -s pdf=evince
alias -s jpg=gqview
alias -s png=gqview
alias -s eps=gqview
alias -s gif=gqview
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

export VIRTUAL_ENV_DISABLE_PROMPT=1


#if [[ $TERM == "xterm" ]] && [[ $COLORTERM == "gnome-terminal" ]]; then
#    export TERM="xterm-256color"
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

#function zle-line-init zle-keymap-select {
#    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$RPROMPT $EPS1"
#    zle reset-prompt
#}
#

#zle -N zle-line-init
#zle -N zle-keymap-select
zle-line-init() { echoti smkx 2>/dev/null; }
zle-line-finish() { echoti rmkx 2>/dev/null; }
zle -N zle-line-init
zle -N zle-line-finish
export KEYTIMEOUT=1

source $HOME/dotfiles/opp.zsh/opp.zsh
source $HOME/dotfiles/opp.zsh/opp/*.zsh


#bindkey -M viins 'jj' vi-cmd-mode

bindkey $terminfo[khome] beginning-of-line
bindkey $terminfo[kend] end-of-line
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

export LESS_TERMCAP_so=$'\E[37;45m'

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
