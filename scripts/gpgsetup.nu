# this script should be sourced and not run directly

export-env {
    $env.GPGKEY = "8AC624881EF2AC30C0E68E2C39FE11201A31555C"
    $env.SSH_VIA_GPG = 0
    $env.GPG_TTY = ^tty
}

# Some help for gpg to pass to others who want to send me something
def gpghelp [] {
    echo $"gpg --recv-key $(env.GPGKEY)"
    echo $"echo \"your secret message here\" | gpg -e --armor -r $(env.EMAIL)"
}

# Encrypt a message for a given recipient (if no recipient is given, it'll be me myself)
def gpgmsg [recipient?: string] {
    gpg -e --armor -r ($recipient | default $env.EMAIL)
}

# Show the ssh public key known by GPG
def gpgsshpubkey [] {
    gpg --export-ssh-key $env.EMAIL
}

# Sign a file (detached). Provide a file as argument, a clear-signed detached *.asc signature will be generated 
def gpgsign [filename: string] {
    gpg --armor --detach-sign $filename
    ls $"($filename).asc"
}

# Sign and replace a file. Provide a file as argument, the original file will be REPLACED with a clear-signed counterpart!
def gpgsignreplace [filename: string] {
    gpg --sign $filename; mv $"($filename).asc" $filename
}

if "XDG_RUNTIME_DIR" in $env {
    #set up ssh-agent without GPG
    do --env {
        let ssh_agent_file = (
            $nu.temp-path | path join $"ssh-agent-($env.USER).nuon"
        )

        if ($ssh_agent_file | path exists) {
            let ssh_agent_env = open ($ssh_agent_file)
            if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
                load-env $ssh_agent_env
                return
            } else {
                rm $ssh_agent_file
            }
        }

        let ssh_agent_env = ^ssh-agent -c
            | lines
            | first 2
            | parse "setenv {name} {value};"
            | transpose --header-row
            | into record
        load-env $ssh_agent_env
        $ssh_agent_env | save --force $ssh_agent_file
    }
}

# To set nitrokey not to demand PIN on every sign action, make sure forcesig is DISABLED
# PIN is still needed on the first interaction

# $ gpg --card-edit 
# > admin
# > forcesig

# then set UIF sign and auth to on as follows, this requires confirmation using physical touch instead

# > uif 1 on
# > uif 1 off



