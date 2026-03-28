My dotfiles
================

![](screenshot.jpg?raw=true)

Software
------------

Current setup:

* 🐧 **OS**: [Arch Linux](https://archlinux.org) (workstation & laptop) & [postmarketOS](https://postmarketos.org) (2nd laptop)
* ⚙ **Compositor**: [River](https://codeberg.org/river/river)
* ⚙ **Window Manager**: [kwm](https://github.com/kewuaa/kwm)
* 🍫 **Bar**: [kwm's bar](https://github.com/kewuaa/kwm) with [custom blocks](scripts/bar.sh)
* 🐚 **Shell**: zsh
* 🤖 **Terminal:** [foot](https://codeberg.org/dnkl/foot)
* 🤖 **Terminal Multiplexer**: tmux
* 📮 Mail Client: [aerc](https://aerc-mail.org)
* 🌐 Web Browser: [Firefox](https://www.mozilla.org/en-US/firefox/)
* 🧮 Code/Text Editor: [neovim](https://neovim.org)
* 📜 Word Processing: [LaTeX](https://www.latex-project.org/) (but more often via Markdown + [pandoc](https://pandoc.org))
* 📊 Presentations: [LaTeX](https://www.latex-project.org/) with beamer (more often via Markdown + pandoc)
* 📜 PDF viewer: [zathura](https://pwmt.org/projects/zathura/)
* 🎥 Media Player: [mpv](https://mpv.io)
* 🎵 Music: [rmpc](https://rmpc.mierak.dev/) (client) or [ncmpcpp](https://rybczak.net/ncmpcpp/) (client) with  [mpd](https://musicpd.org) + [snapcast](https://github.com/badaix/snapcast)
* 📝 Notes: [neovim](https://neovim.org) and markdown files in a git repo
* ✅ To-Do: [todo.txt](https://todotxt.org) with my own [todo.txt-more](https://git.sr.ht/~proycon/todotxt-more) extension.
* 📆 Calendar: [todo.txt-more](https://git.sr.ht/~proycon/todotxt-more)
* 🗞️ RSS Client:  [newsraft](https://codeberg.org/newsraft/newsraft)
* 🎤 Podcasts: same as above
* ⌨️ Launcher:  [bemenu](https://github.com/Cloudef/bemenu)
* 🌅 Photo viewer: [swayimg](https://github.com/artemsen/swayimg)
* 🌅 Photo editing: [gimp](https://gimp.org)
* 🌅 Image editing (vector): [inkscape](https://inkscape.org)
* 📹 Video editing: [kdenlive](https://kdenlive.org)
* 💬 Chat: [senpai](https://sr.ht/~taiite/senpai/) + [soju](https://git.sr.ht/~emersion/soju) (IRC), [nheko](https://nheko-reborn.github.io/) (Matrix, using bridges for Signal, Discord, Telegram), [Dino](https://dino.im/) (XMPP)
* 🔖 Bookmarks: [buku](https://github.com/jarun/Buku) + bemenu script
* 🔐 Password Management: [pass](https://www.passwordstore.org/)
* 🛩 Flight Simulator: [X-Plane 12](https://www.x-plane.com/) with [simheaven](https://simheaven.com/), [LittleNavMap](https://albar965.github.io/), 
* 🤦 Social Media: [Mastodon](https://social.anaproy.nl/@proycon)

Install
--------------

You probably don't want to use the install method if you're not me, but rather
just pick and copy things you like into your own setup.

If you are me, you (me) can install all dotfiles including **all system
packages I use for my system** as follows:

```
$ make install
```

On Arch Linux this essentially provisions and entire desktop system. The script
is idempotent so can be rerun freely.

However, to forcibly update some things as well, use this instead:

```
$ make update
```

Key bindings
--------------

* **river**
    * TODO, very comparable to what I had for dwm though
* **dwm**
    * ``cmd+1,2,3,4,5,6,7,8,9`` - switch tags/workspace
    * ``cmd+Shift+1,2,3,4,5,6,7,8,9`` - move window to selected workspaces
    * ``cmd+tab`` - Switch to last used workspace (and back)
    * ``cmd+period`` - switch to right monitor
    * ``cmd+comma`` - switch to left monitor
    * ``cmd+Shift+period`` - move window to right monitor
    * ``cmd+Shift+comma`` - move windows to left monitor
    * ``cmd+space`` - Launcher (kickoff)
    * ``cmd+shift+space`` - Launcher (fuzzel)
    * ``cmd+enter`` - Put window in focus/master area
    * ``cmd+Shift+enter`` - New terminal
    * ``cmd+j|k`` - cycle window focus
    * ``cmd+l|h`` - resize master window
    * ``cmd+ctrl+delete`` - Quit
    * ``cmd+Escape`` - Lock
    * ``cmd+Shift+Escape`` - Suspend
    * Layouts:
        * ``cmd+t`` - Switch to tiling layout
        * ``cmd+m`` - Monocle layout
        * ``cmd+g`` - Grid layout
        * ``cmd+s`` - Scroll layout
        * ``cmd+Shift+apostrophe`` - toggle floating
    * Timetracker:
        * ``cmd+slash`` - Timetracker
        * ``cmd+Shift+slash`` - Stop tracking
* **tmux**
    * ``alt+left/right/up/down`` - Switch pane
    * ``alt+pageup/pagedown`` - Switch window
    * ``ctrl+a`` (prefix)
        * ``(number)`` - Switch window
        * ``c`` - New window
        * ``"`` - New pane (horizontal split)
        * ``%`` - New pane (vertical split)
        * ``ctrl+a`` - Switch to last window (and back)
        * ``;`` - Switch to last pane (and back)
        * ``space`` - Switch pane layout (cycles through a few), good for turning vertical panes horizontal and vice
          versa
        * ``,`` - Rename window
        * ``/`` - Flip/swap
        * ``x`` - Kill pane
        * ``z`` - zoom pane
        * ``!`` - Break pane (to its own window)
        * ``l`` - Clear history
        * ``r`` - reload
        * ``v`` - copy mode
            * VI bindings (v,y,w,/,hjkl etc..)
        * ``P`` - paste buffer
        * ``W`` - Swap window
        * ``Q`` - Swap pane
        * ``M`` - Move pane (to another window or tmux)
        * ``F`` - Fingers mode
* vim
    * leader is space
    * navigate popup menus with C-j C-k
    * spelling
        * ``z=`` -- spelling suggestion
        * ``:set spelllang``
    * buffers
        * ``C-^`` -- previous buffer
    * telescope
        * ``<leader> o`` - git files
        * ``<leader> f`` - find files
        * ``<leader> b`` - find buffers
        * ``<leader> F`` - find inside files (live grep)
    * building
        * ``F4`` - Build and preview (syncronously) (tex, markdown); pip install . (python)
        * ``F5`` - Build and preview (asyncronously) (tex, markdown); pip install . (python)
    * git (tpope/fugitive)
        * ``F9`` - Commit
        * ``F10`` - Push
    * documentation/navigation/LSP
        * ``K`` - documentation
        * ``<space>lc`` - Incoming calls
        * ``<space>lC`` - Outgoing calls
        * ``<space>ld`` - Goto definition
        * ``gi`` - Goto implementation
        * ``gr`` - goto references
        * ``ga`` - show (unicode) character information
    * editing
        * ``<space>_`` - strip trailing whitespace
        * visual mode
            * ``gc`` - (un)comment selection


