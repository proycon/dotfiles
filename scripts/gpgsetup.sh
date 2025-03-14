#!/bin/sh

# this script should be sourced and not run directly

gpghelp() {
    echo "gpg --recv-key 8AC624881EF2AC30C0E68E2C39FE11201A31555C"
    echo "echo \"your secret message here\" | gpg -e --armor -r proycon@anaproy.nl"
}

gpgmsg() {
    if [ -n "$1" ]; then
        gpg -e --armor -r "$1"
    else
        gpg -e --armor -r proycon@anaproy.nl
    fi
}

gpgsshpubkey() {
    gpg --export-ssh-key proycon@anaproy.nl
}

gpgsign() {
    if [ -n "$1" ]; then
        gpg --armor --detach-sign "$1"
    else
        echo "Usage: provide a file as argument, it will be signed detached (*.asc)" >&2
    fi
}

gpgsignreplace() {
    if [ -n "$1" ]; then
        gpg --sign "$1" && mv "$1.asc" "$1"
    else
        echo "Usage: provide a file as argument, the original file will be REPLACED with a clear-signed counterpart" >&2
    fi
}

export GPGKEY="8AC624881EF2AC30C0E68E2C39FE11201A31555C"

SSH_VIA_GPG=0

if [ $SSH_VIA_GPG -eq 1 ]; then
    #SSH via GPG this relies on:
    # 1. keygrip for subkey in  ~/.gnupg/sshcontrol
    #    (obtain keygrip via gpg --list-keys --with-keygrip proycon@anaproy.nl)
    # 2. enable-ssh-support in ~/.gnupg/gpg-agent.conf
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      export SSH_AUTH_SOCK
    fi
fi

GPG_TTY=$(tty)
export GPG_TTY

if [ $SSH_VIA_GPG -eq 1 ]; then
    gpg-connect-agent updatestartuptty /bye >/dev/null
else
    #set up ssh-agent without GPG
	if [ -n "$XDG_RUNTIME_DIR" ]; then
	    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	        ssh-agent -t 12h > "$XDG_RUNTIME_DIR/ssh-agent.env"
	    fi
	    if [ ! "$SSH_AUTH_SOCK" ] && [ -e "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
	        . "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
	    fi
	fi
fi

# To set nitrokey not to demand PIN on every sign action, make sure forcesig is DISABLED
# PIN is still needed on the first interaction

# $ gpg --card-edit 
# > admin
# > forcesig

# then set UIF sign and auth to on as follows, this requires confirmation using physical touch instead

# > uif 1 on
# > uif 1 off



