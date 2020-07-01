#!/bin/zsh
#
DOMAIN=$(hostname -d)

# Based on gnzh theme, Based on bira theme

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%M%f' # no SSH
fi

if [[ $HOST == "rocinante" ]] {
	PR_HOST="%F{green}%m%f"
} elif [[ $HOST == "mhysa" || $HOST == "drasha" ]] {
	PR_HOST="%F{blue}%m%f"
} elif [[ $HOST == "proyphone" ]] {
	PR_HOST="%F{cyan}%m%f"
} elif [[ $HOST == "roma" || $DOMAIN == "anaproy.nl" || $DOMAIN == "anaproy.lxd" ]] {
	PR_HOST="%F{yellow}%M%f"
} elif [[ $HOST == 'applejack' ]] || [[ $HOST == 'mlp01' ]]   {
	PR_HOST="%F{red}%}%m%f"
} elif [[ -f /etc/profile.d/mlp.sh ]] {
    HOSTNAME=$HOST
    source /etc/profile.d/mlp.sh
    PR_HOST="%F{173}${PONY} %m%f"
} else {
	PR_HOST="%F{white}%m%f"
}


local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
local current_dir="%B%F{blue}%~%f%b"
local git_branch='$(git_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'
local datetime="%F{white}%* - %D{%a %f %b}%f"
local seqnr="%F{white}#%i%f"
local promptsign="%{$fg_bold[yellow]%}\$%{$reset_color%} "

if [[ $HOST != "proyphone" ]]; then
    PROMPT="╭─ ${user_host} ${current_dir} ${venv_prompt} ${git_branch} ─── ${datetime} ─── ${seqnr} ${return_code}
╰─$PR_PROMPT${promptsign}"
else
    PROMPT="╭─ ${user_host} ${current_dir} ${venv_prompt} ${git_branch}  ${return_code}
╰─$PR_PROMPT${promptsign}"
fi
#RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ∆"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ∂"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ◊"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ≠"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ≈"

ZSH_THEME_VIRTUALENV_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"
}
