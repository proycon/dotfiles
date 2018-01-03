#!/bin/zsh

if [[ $HOST == "caprica" ]] {
	host="{$fg[cyan]%}@%m%{$reset_color%}"
} elif [[ $HOST == "mhysa" || $HOST == "drasha" ]] {
	host="{$fg_bold[blue]%}@%m%{$reset_color%}"
} elif [[ $HOST == "roma" ]] {
	host="{$fg_bold[yellow]%}@%m%{$reset_color%}"
} elif [[ $HOST == 'applejack' ]] || [[ $HOST == 'mlp01' ]]   {
	host="{$fg_bold[red]%}@%m%{$reset_color%}"
} elif [[ -f /etc/profile.d/mlp.sh ]] {
    HOSTNAME=$HOST
    source /etc/profile.d/mlp.sh
    host="{$fg_bold[magenta]%}@$PONY(%m)%{$reset_color%}"
} else {
	host="{$fg_bold[white]%}@%m%{$reset_color%}"
}

local user='%{$fg_bold[white]%}%n%$host%}'
local pwd='%{$fg_bold[cyan]%}%~%{$reset_color%}'
#local rvm='%{$fg[green]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
local return_code='%(?..%{$fg_bold[red]%}%? ←%{$reset_color%})'
#local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'
local vi_prompt='$(vi_mode_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ∆"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ∂"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ◊"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ≠"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ≈"

ZSH_THEME_VIRTUALENV_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"


#if [ -n "$JOB_NAME" ]; then
#    PROMPT="${user} ${pwd} %{$fg_bold[grey]%}job:${JOB_NAME}%{$reset_color%}$ "
#else
PROMPT="${user} ${pwd} ${venv_prompt} %{$fg_bold[yellow]%}$%{$reset_color%} "
#fi
RPROMPT="${return_code} ${vi_prompt} ${git_branch} %{$fg[yellow]%}%* %w%{$reset_color%}"
