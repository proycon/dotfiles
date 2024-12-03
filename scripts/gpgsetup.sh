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

export GPGKEY="8AC624881EF2AC30C0E68E2C39FE11201A31555C"

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi
GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye >/dev/null

#this relies on:
# 1. keygrip for subkey in  ~/.gnupg/sshcontrol
#    (obtain keygrip via gpg --list-keys --with-keygrip proycon@anaproy.nl)
# 2. enable-ssh-support in ~/.gnupg/gpg-agent.conf
