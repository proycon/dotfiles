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
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(history history-substring-search git svn python django command-not-found debian pip github git-flow )


source $ZSH/oh-my-zsh.sh

setopt cshnullglob
unsetopt correct_all



#apps
alias x='wrexp'
alias xh='wrexp history'
alias exp='wrexp'
alias hr="echo '_____________________________________________________________________________________'"
alias en='LANGUAGE="en_US.UTF-8" zsh'
alias km="setxkbmap proylatin"
alias m='mutt'
alias mk='LANGUAGE="en_GB.UTF-8" make'
alias mi='LANGUAGE="en_GB.UTF-8" make install; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Sys-App-Positive.ogg 2> /dev/null &!; else; play -q /usr/share/sounds/KDE-K3B-Finish-Error.ogg 2> /dev/null &!; fi; hr'
alias glmi='git pull && LANGUAGE="en_GB.UTF-8" make install; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Sys-App-Positive.ogg 2> /dev/null &!; else; play -q /usr/share/sounds/KDE-K3B-Finish-Error.ogg 2> /dev/null &!; fi; hr'
alias gl='git pull; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Minimize.ogg 2> /dev/null &!; fi'
alias gp='git push; if (( $? == 0 )); then; play -q /usr/share/sounds/KDE-Window-Maximize.ogg 2> /dev/null &!; fi'
alias cf='LANGUAGE="en_GB.UTF-8" ./configure'
alias t='~/todo/todo.sh'
alias tls='~/todo/todo.sh ls'
alias tlsw='~/todo/todo.sh ls @work'
alias tlsh='~/todo/todo.sh ls @home'
alias tlsp='~/todo/todo.sh projectview @work'
alias tgl='cd ~/todo && git pull && cd -'
alias tgp='cd ~/todo && ((git commit -a -m "todo update" && git push && cd -) || cd - )'
alias a='tmux attach'
alias ta='~/todo.sh add'
alias ka='killall'
alias gpp='git push origin gh-pages'
#colours
alias g="grep -n --color=auto"
alias grep='grep --color=no'
alias fgrep='fgrep -n --color=auto'
alias egrep='egrep -n --color=auto'
which colorgcc > /dev/null 2> /dev/null
if (( $? == 0 )); then
    export CC="colorgcc"
fi
alias vless='vim -R -u /usr/share/vim/vim72/macros/less.vim'
alias l='ls'
alias z='less -rN'
#alias less='less -rN'

export MPD_HOST="proycon@anaproy.nl"

export GPGKEY="1A31555C"

export EDITOR="vim"

#PATHS
if [[ $HOST == "galactica" || $HOST == "mhysa" ]]; then
    export PATH="/home/proycon/bin:/home/proycon/local/bin:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools:$PATH"
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
    export PATH="/home/proycon/bin:/home/proycon/local/bin:$PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/proycon/local/lib"
    export PYTHONPATH="/home/proycon/work/"
    export ALPINO_HOME="/usr/local/Alpino"
    export CDPATH=.:~/work
    
    hash -d X=/home/proycon/exp
    hash -d lsrc=/home/proycon/local/src/
    hash -d clb=/home/proycon/work/colibri/
    hash -d cta=/home/proycon/work/colibrita/
    hash -d W=/home/proycon/work
elif [[ $HOST == "applejack" || $HOST == "fluttershy" || $HOST == "rarity" || $HOST == "cheerilee" || $HOST == "fancypants" || $HOST == "pipsqueak" || $HOST == "scootaloo" ]]; then

    export LD_LIBRARY_PATH="/scratch/proycon/local/lib:/home/proycon/local/lib:/vol/customopt/uvt-ru/lib:/vol/customopt/machine-translation/lib:/vol/customopt/nlptools/lib/:$LD_LIBRARY_PATH"
    export PATH="/scratch/proycon/local/bin:/home/proycon/bin:/home/proycon/local/bin:/vol/customopt/machine-translation/bin:/vol/customopt/uvt-ru/bin:/vol/customopt/alpino/bin:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/nlptools/bin/:/vol/customopt/nlptools/cmd/:/vol/customopt/cython3/bin/:$PATH"
    export CDPATH=.:/scratch/proycon/:/scratch/proycon/local/:/scratch/proycon/local/src/
    export PYTHONPATH="/home/proycon/:/vol/customopt/uvt-ru/lib/python2.7/site-packages/:/vol/customopt/uvt-ru/src/colibri/scripts:/vol/customopt/uvt-ru/lib/python2.7/site-packages/frog/:/vol/customopt/nlptools/stanford-corenlp-python:/vol/customopt/uvt-ru/lib/python3.2/site-packages/:/vol/customopt/python3-packages/lib/python3.2/site-packages/"
    export CLASSPATH="/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4.jar:/vol/customopt/nlptools/stanford-corenlp-full/stanford-corenlp-1.3.4-models.jar:/vol/customopt/nlptools/stanford-corenlp-full/xom.jar:/vol/customopt/nlptools/stanford-corenlp-full/joda-time.jar:/vol/customopt/nlptools/stanford-corenlp-full/jollyday.jar:/vol/customopt/nlptools/javalib:."
    export FREELINGSHARE="/vol/customopt/nlptools/share/freeling/"
    export PARAMSEARCH_DIR="/vol/customopt/uvt-ru/src/paramsearch"
    export ALPINO_HOME="/vol/customopt/alpino/"

    hash -d X=/scratch/proycon/
    hash -d lsrc=/scratch/proycon/local/src
    hash -d corpora=/vol/bigdata/corpora/
    hash -d ur=/vol/customopt/uvt-ru/
    hash -d clb=/vol/customopt/uvt-ru/src/colibri/
    hash -d cta=/vol/customopt/uvt-ru/src/colibrita/
    hash -d mt=/vol/customopt/machine-translation/
    hash -d corp=/vol/bigdata/corpora/
    hash -d bd=/vol/bigdata/users/proycon/
    hash -d ws=/scratch2/www/webservices-lst/live

    umask u=rwx,g=rx,o=rx
fi


#if [[ -f  /usr/share/source-highlight/src-hilite-lesspipe.sh ]]; then
#    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
#fi


alias ap='ssh -Y -A anaproy.nl'
alias ssha='ssh -Y -A anaproy.nl'
alias sshat='ssh -Y -A anaproy.nl tmux attach'
alias e='ssh -Y -A -t anaproy.nl /home/proycon/bin/tm_vi'
alias sshilk='ssh mvgompel@radium.uvt.nl'
alias lo="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo3.science.ru.nl zsh"
alias aj="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t applejack /home/proycon/bin/tm"
alias fs="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t fluttershy /home/proycon/bin/tm"
alias rr="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t rarity /home/proycon/bin/tm"
alias cl="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t cheerilee /home/proycon/bin/tm"
alias fp="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t fancypants /home/proycon/bin/tm"
alias pq="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t pipsqueak /home/proycon/bin/tm"
alias so="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t scootaloo /home/proycon/bin/tm"
alias _aj="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t applejack zsh"
alias _fs="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t fluttershy zsh"
alias _rr="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t rarity zsh"
alias _cl="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t cheerilee zsh"
alias _fp="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t fancypants zsh"
alias _pq="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t pipsqueak zsh"
alias _so="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t scootaloo zsh"
alias _sc="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t mvgompel@radium.uvt.nl ssh -Y -A -t scylla zsh"
alias st="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t mvgompel@radium.uvt.nl ssh -Y -A -t stheno zsh"
alias ct="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t mvgompel@radium.uvt.nl ssh -Y -A -t ceto zsh"
alias rv="LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ssh -Y -A -t lilo.science.ru.nl ssh -Y -A -t applejack /home/proycon/bin/tm_vi"
alias homsar="ssh -Y -A -t homsar.uvt.nl zsh"
alias luon="ssh -Y -A -t maartenvg@void.luon.net"

alias py="python"
alias py3="python3"
alias ipy="ipython"
alias ipy3="ipython3"

alias ipyq="ipython qtconsole"
alias ipyq3="ipython3 qtconsole"

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

alias -s html=chromium-browser

if [[ $HOST == "galactica" ]]; then
    export GTK_IM_MODULE="ibus"
    export QT_IM_MODULE="ibus"
    export XMODIFIERS="@im=ibus"
fi

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

export TERM=xterm-256color
export PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")' #tmux-powerline support

bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
bindkey '^H' history-substring-search-up
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
