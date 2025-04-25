# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = 'vi'

export-env {
    $env.MPD_HOST = "anaproy.nl"
    $env.REALNAME = "Maarten van Gompel"
    $env.EMAIL = "proycon@anaproy.nl"
    $env.DEBEMAIL = "proycon@anaproy.nl"
    $env.DEBFULLNAME = "Maarten van Gompel"
    $env.BROWSER = "firefox"
    $env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
    $env.TODO_DIR = $"($env.HOME)/.todo"
    $env.BAT-THEME = "gruvbox-dark"
    $env.PINENTRY_USER_DATA = "curses"
}

use std/dirs
use std/log

def resultsound [returncode sound_ok sound_fail] {
   if $returncode == 0 {
       if ($"($env.HOME)/dotfiles/media/($sound_ok)" | path exists) {
           job spawn { mpv --really-quiet $"($env.HOME)/dotfiles/media/($sound_ok)" | ignore } | ignore
       } else {
           log warning "ok sound not found"
        }
   } else {
       if ($"($env.HOME)/dotfiles/media/($sound_fail)" | path exists) {
           job spawn { mpv --really-quiet $"($env.HOME)/dotfiles/media/($sound_fail)" | ignore } | ignore
       } else {
           log warning "fail sound not found"
       }
   }
}

#def mkenv [] {
#    if not ("env" | path exists) { virtualenv env };  overlay use env/bin/activate.nu
#}
#def mk.env [] { 
#    if not (".env" | path exists) { virtualenv .env };  overlay use .env/bin/activate.nu
#}

#alias glgh= 'sshcheck && git pull github $(git branch --show-current) && git submodule update; resultsound $env.LAST_EXIT_CODE wipe.wav boing.wav'
#alias glsrht= 'sshcheck && git pull srht $(git branch --show-current) && git submodule update; resultsound $env.LAST_EXIT_CODE wipe.wav boing.wav'
#alias glu = 'sshcheck && git pull upstream $(git branch --show-current) && git submodule update; resultsound $env.LAST_EXIT_CODE wipe.wav boing.wav'
#alias gf = 'sshcheck && git fetch -a'
alias gp = git push; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
#alias gpgh = 'sshcheck && git push github $(git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav'
#alias gpsrht= 'sshcheck && git push srht $(git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav'
#alias gpcb = 'sshcheck && git push codeberg $(git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav'
#alias gpu = 'sshcheck && git push upstream $(git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav'
alias gca = git commit -a
alias pm = podman
alias pmc = podman-compose
alias a = tmux attach
alias b = buku
alias i = img2sixel
alias ka = killall
alias za = zathura
alias sx = sxiv -t .
#alias gpp='git push origin gh-pages'
#alias mp="ncmpcpp -b ~/dotfiles/ncmpcpp.bindings"
alias t = todo.sh more
#alias CD='cd $(cat ${XDG_CONFIG_HOME:-$HOME/.config}/directories | fzf)'
alias hs = ~/dotfiles/scripts/homestatus.sh
alias yz = yazi
alias yy = yazi
#alias ttw=`tw --separator="	"`
alias ghils = gh issue list
alias ghls = gh issue list
alias ghic = gh issue create
alias ghiv = gh issue view
alias ghicm = gh issue comment
alias gr = git remote
#alias protontricks-flat="flatpak run com.github.Matoking.protontricks"
alias hutsxmo = hut lists patchset list ~mil/sxmo-devel
alias hutsxmo2 = hut todo ticket list -t ~mil/sxmo-tickets
alias surfdrive = rclone ls surfdrive_knaw:
alias lh = linkhandler
alias myip = dig +short myip.opendns.com @resolver1.opendns.com
alias whatismyip = dig +short myip.opendns.com @resolver1.opendns.com
alias vi = nvim
alias vim = nvim
alias l = ls -l
alias gL = gitlog
alias gB = gitbranches
alias xl = translate.sh

def gl []  {
    git pull; git submodule update; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
def glmi [] {
    git pull; git submodule update; make install; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
def glsi []  {
    git pull; git submodule update; pip install .; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
def pi [] {
    pip install .; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
def cb [] {
    cargo build; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
def cbr [] {
    cargo build --release; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
def gpa [] {
    echo "default: "; gp
    let remotes = git remote | lines
    if ($remotes | where {|x| $x == "github"}) { echo "github: "; gpgh }
    if ($remotes | where {|x| $x == "srht"}) { echo "sourcehut: "; gpsrht }
    if ($remotes | where {|x| $x == "codeberg"}) { echo "codeberg: "; gpcb }
}
def gfa [] {
    let remotes = git remote | lines
    if ($remotes | where {|x| $x == "github"}) { echo "github: "; git fetch github }
    if ($remotes | where {|x| $x == "srht"}) { echo "sourcehut: "; git fetch sourcehut }
    if ($remotes | where {|x| $x == "codeberg"}) { echo "codeberg: "; git fetch codeberg }
}


def qr [url] {
    curl -s $"http://qrenco.de/($url | url encode)"
}

#source: https://github.com/nushell/nu_scripts/blob/main/sourced/cool-oneliners/cargo_search.nu , license: MIT
def "cargo search" [ query: string, --limit=10] { 
    ^cargo search $query --limit $limit
    | lines 
    | each { 
        |line| if ($line | str contains "#") { 
            $line | parse --regex '(?P<name>.+) = "(?P<version>.+)" +# (?P<description>.+)' 
        } else { 
            $line | parse --regex '(?P<name>.+) = "(?P<version>.+)"' 
        } 
    } 
    | flatten
}

source ~/dotfiles/scripts/scrapers.nu
source ~/dotfiles/scripts/ollama.nu

# prompt
if ((which nushell | length) > 0) {
    mkdir ($nu.data-dir | path join "vendor/autoload")
    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

# autocompletion
if ((which carapace | length) > 0) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash'
    mkdir ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

    source ~/.cache/carapace/init.nu
}

source ~/dotfiles/scripts/gpgsetup.nu

plugin use highlight
$env.config.plugins.highlight.theme = "gruvbox-dark"
source ~/.zoxide.nu
