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
$env.config.menus = [
      {
        name: completion_menu
        only_buffer_difference: false # Search is done on the text written after activating the menu
        marker: "⎁ "                  # Indicator that appears with the menu is active
        type: {
            layout: columnar          # Type of menu
            columns: 4                # Number of columns where the options are displayed
            col_width: 20             # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2            # Padding between columns
        }
        style: {
            text: green                   # Text style
            selected_text: green_reverse  # Text style for selected option
            description_text: yellow      # Text style for description
        }
      },
       {
        name: history_menu
        only_buffer_difference: false # Search is done on the text written after activating the menu
        marker: "⌂ "                 # Indicator that appears with the menu is active
        type: {
            layout: list             # Type of menu
            page_size: 10            # Number of entries that will presented when activating the menu
        }
        style: {
            text: green                   # Text style
            selected_text: green_reverse  # Text style for selected option
            description_text: yellow      # Text style for description
        }
      }
]
$env.config.completions.algorithm = "fuzzy"
$env.config.keybindings = [
     {
      name: change_dir_with_fzf
      modifier: control
      keycode: char_f
      mode: [ emacs, vi_normal, vi_insert ],
      event: {
        send: executehostcommand,
        cmd: "F"
      }
    },
    {
    name: fuzzy_history_fzf
    modifier: control
    keycode: char_r
    mode: [emacs , vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (
        history
          | get command
          | reverse
          | uniq
          | str join (char -i 0)
          | fzf --scheme=history --read0 --tiebreak=chunk --layout=reverse --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline) --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
          | decode utf-8
          | str trim
      )"
    }
  }
]

export-env {
    $env.MPD_HOST = "anaproy.nl"
    $env.REALNAME = "Maarten van Gompel"
    $env.EMAIL = "proycon@anaproy.nl"
    $env.DEBEMAIL = "proycon@anaproy.nl"
    $env.DEBFULLNAME = "Maarten van Gompel"
    $env.BROWSER = "firefox"
    $env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
    $env.TODO_DIR = $"($env.HOME)/.todo"
    $env.PINENTRY_USER_DATA = "curses"
    $env.PAGER = try { (which bat).0.cmd } catch { "less" }
    $env.BAT_PAGER = "less"
    $env.BAT_THEME = "gruvbox-dark"
    $env.PROMPT_INDICATOR_VI_INSERT = "⎆ "
    $env.PROMPT_INDICATOR_VI_NORMAL = "⎌ "
}

use std/dirs
use std/log
use std/util "path add"

path add "~/.cargo/bin"
path add "~/.local/bin"
path add "~/bin"

def resultsound [returncode sound_ok sound_fail] {
   if $returncode == 0 {
       if ($"($env.HOME)/dotfiles/media/($sound_ok)" | path exists) {
           try {
               job spawn { mpv --really-quiet $"($env.HOME)/dotfiles/media/($sound_ok)" | ignore } | ignore
           } catch {
               #fallback for nushell <0.103 without job 
               mpv --really-quiet $"($env.HOME)/dotfiles/media/($sound_ok)" | ignore
           }
       } else {
           log warning "ok sound not found"
        }
   } else {
       if ($"($env.HOME)/dotfiles/media/($sound_fail)" | path exists) {
           try {
               job spawn { mpv --really-quiet $"($env.HOME)/dotfiles/media/($sound_fail)" | ignore } | ignore
           } catch {
               #fallback for nushell <0.103 without job 
               mpv --really-quiet $"($env.HOME)/dotfiles/media/($sound_ok)" | ignore
           }
       } else {
           log warning "fail sound not found"
       }
   }
}

# Make or activate virtual python environment. Note that nushell variables from the current shell are not passed as this is a new subshell!
def mkenv [envname?: string] {
    #this will launch a subshell so non-environment variables from current shell are lost
    if ($envname == "" or $envname == null) {
        mkenv "env"
    } else {
        if not ($envname | path exists) { virtualenv $envname };  nu -e $"$env.VIRTUAL_ENV_DISABLE_PROMPT = true; overlay use ($envname)/bin/activate.nu; "
    }
}

def --wrapped man [...args] {
    $env.GROFF_NO_SGR = 1
    $env.LESS_TERMCAP_mb = ansi --escape '01;31m'  #\E[01;31m'
    $env.LESS_TERMCAP_md = ansi --escape '01;38;5;74m'  #\E[01;38;5;74m' 
    $env.LESS_TERMCAP_me = ansi reset
    $env.LESS_TERMCAP_se = ansi reset
    $env.LESS_TERMCAP_ue = ansi reset
    $env.LESS_TERMCAP_us = ansi --escape '04;38;5;146m' #$'\E[04;38;5;146m'
    ^man ...$args
}

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
alias gco = git checkout
alias gb = git branch
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


# Git pull
def gl []  {
    git pull; git submodule update; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Git pull and make install
def glmi [] {
    git pull; git submodule update; make install; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Git pull and pip install
def glsi []  {
    git pull; git submodule update; pip install .; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Pip install
def pi [] {
    pip install .; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Cargo build
def cb [] {
    cargo build; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}
# Cargo build --release
def cbr [] {
    cargo build --release; resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Git push to github
def gpgh [] {
    git push github (git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Git push to sourcehut
def gpsrht [] {
    git push srht (git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Git push to codeberg
def gpcb [] {
    git push srht (git branch --show-current); resultsound $env.LAST_EXIT_CODE submit.wav boing.wav
}

# Git push all remotes 
def gpa [] {
    echo "default: "; gp
    let remotes = git remote | lines
    if ("github" in $remotes) { echo "github: "; gpgh}
    if ("srht" in $remotes) { echo "srht: "; gpsrht }
    if ("codeberg" in $remotes) { echo "codeberg: "; gpcb }
}

# Git fetch all remotes 
def gfa [] {
    let remotes = git remote | lines
    if ("github" in $remotes) { echo "github: "; git fetch github }
    if ("srht" in $remotes) { echo "srht: "; git fetch srht }
    if ("codeberg" in $remotes) { echo "codeberg: "; git fetch codeberg }
}

# Get vatsim Air-traffic controllers online in Europe
def vatsim [] {
    http get https://api.vatsim.net/v2/atc/online | where callsign =~ "^[LE].*" | sort-by callsign
}


# Generate QR code on the terminal
def qr [url] {
    curl -s $"http://qrenco.de/($url | url encode)"
}

# build an ssh tunnel SSH tunnel
def sshtunnel [targethost: string, port: int] {
    ssh -N -f -L $"localhost:($port):localhost:$(port)" $targethost
}

# Cargo search
# source: https://github.com/nushell/nu_scripts/blob/main/sourced/cool-oneliners/cargo_search.nu , license: MIT
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

# Fuzzy filefinder and linkhandler
def F --env () {
    let result = fd --color=always | fzf --ansi --preview='nu ~/dotfiles/scripts/preview.nu {}'
    if ($result | path type) == "dir" {
        cd $result
    } else if ($result != "") {
        linkhandler $result
    }
}

# Fuzzy directory finder
def D --env () {
    let result = fd -t d --color=always | fzf --ansi --preview='nu ~/dotfiles/scripts/preview.nu {}'
    if $result != "" {
        cd $result
    }
}
# Fuzzy filefinder and linkhandler (edit mode)
def E --env () {
    let result = fd --color=always | fzf --ansi --preview='nu ~/dotfiles/scripts/preview.nu {}'
    if ($result | path type) == "dir" {
        cd $result
    } else if ($result != "") {
        $env.TARGET = "edit"
        linkhandler $result
        hide-env TARGET
    }
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
