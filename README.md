My dotfiles
================

![](screenshot.jpg?raw=true)

Software
------------

Current setup:

* **OS**: Arch Linux
* **Window Manager**: [dwm](https://github.com/proycon/dwm)
* **Shell**: zsh
* **Terminal:** alacritty
* **Terminal Multiplexer**: tmux
* **Editor**: neovim
* **Browser**: firefox
* **Music player**: ncmpcpp + mopidy
* **Mail**: neomutt
* **Chat**: weechat + bitblee (IRC+XMPP+Twitter+Telegram) + weechat-matrix (Matrix)

Key bindings
--------------

* **dwm**
    * ``cmd+1,2,3,4,5,6,7,8,9`` - switch tags/workspace
    * ``cmd+Shift+1,2,3,4,5,6,7,8,9`` - move window to selected workspaces
    * ``cmd+tab`` - Switch to last used workspace (and back)
    * ``cmd+period`` - switch to right monitor
    * ``cmd+comma`` - switch to left monitor
    * ``cmd+Shift+period`` - switch to right monitor
    * ``cmd+Shift+comma`` - switch to left monitor
    * ``cmd+space`` - Launcher (rofi)
    * ``cmd+enter`` - Put window in focus/master area
    * ``cmd+Shift+enter`` - New terminal
    * ``cmd+j|k`` - cycle window focus
    * ``cmd+l|h`` - resize master window
    * ``cmd+s`` - toggle sticky
    * ``cmd+Shift+backspace`` - Quit dwm (auto restarts)
    * ``cmd+Escape`` - Lock
    * ``cmd+Shift+Escape`` - Suspend
    * Layouts:
        * ``cmd+t`` - Switch to tiling layout
        * ``cmd+m`` - Monocle layout
        * ``cmd+apostrophe`` - cycle layouts
        * ``cmd+Shift+apostrophe`` - toggle floating
    * Timetracker:
        * ``cmd+slash`` - Timetracker
        * ``cmd+Shift+slash`` - Timetracker 15 minutes back
        * ``cmd+Ctrl+Shift+slash`` - Timetracker 60 minutes back
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
        * ``Y`` - copy existing buffer to X clipboard and ``~/.vbuf``
        * ``I`` - Paste from ``~/.vbuf`` (mnemonic: Insert from vim)
        * ``O`` - Paste from X clipboard
        * ``W`` - Swap window
        * ``Q`` - Swap pane
        * ``M`` - Move pane (to another window or tmux)
        * ``F`` - Fingers mode
* vim
    * leader is space or comma
    * fzf - fuzzy matcher
        * type ``:Maps`` to see all custom keymaps and search
        * ``ctrl-p`` or ``,o`` - git files
        * ``ctrl-f`` or ``,O`` - all files
        * ``ctrl-m`` - marks
        * ``ctrl-b`` or ``,b`` - buffers
        * ``ctrl-g`` - git commits
        * ``,n`` - lines (buffer)
        * ``,N`` - lines (all)
        * ``,r`` - tags
    * buffers
        * ``,=`` or ``ctrl-right`` - next
        * ``,-`` or ``ctrl-left`` - previous
        * ``,1`` - buffer 1, etc..
        * ``,,`` - last buffer
        * ``<space><space>`` - last buffer
        * ``,e`` - reload current buffer
        * ``,x`` - close current buffer
        * ``,E`` - reload all buffers
    * building
        * ``F4`` - Build and preview (syncronously) (tex, markdown); pip install . (python)
        * ``F5`` - Build and preview (asyncronously) (tex, markdown); pip install . (python)
    * git (tpope/fugitive)
        * ``F9`` - Commit
        * ``F10`` - Push
    * documentation/navigation
        * ``,K`` - keyword documentation
        * ``,ga`` - Goto assignment (jedi/python)
        * ``,gd`` - Goto definition (jedi/python)
        * ``,gu`` - Show usages (places where it is used) (jedi/python)
    * editing
        * ``,_`` - strip trailing whitespace
        * tpope/surround.vim
            * ``cs``XY - change surround tag X to Y (understand XML tags too)
            * ``ds``X - delete surround tag X
        * visual mode
            * ``,s`` - sort
    * copy/paste
        * ``,y`` - yank selection (to ~/.vbuf and X clipboard)
        * ``,p`` - paste
        * ``,P`` - paste before
    * toggle plugins
        * ``,t`` - Toggle tagbar
        * ``,f`` - Toggle file browser (nerdTree)
        * ``,ig`` - Toggle Indentation Guides
        * ``ga`` - show (unicode) character information
    * coc.nvim
        * ``K`` - documentation
        * ``,d`` - open diagnostic window
        * ``,c`` - next diagnostic
        * ``,C`` - previous diagnostic
        * ``gd`` - goto definition
        * ``gy`` - goto type definition
        * ``gi`` - goto implementation
        * ``gr`` - goto references
        * ``,a`` - codeaction on selection
        * ``,F`` - (re)format
    * miscellaneous
        * ``,L`` - Lost where you are in a file? Show a context clue
* **weechat**
    * ``ctrl+s`` or ``ctrl+u`` - Set unread marker on all windows
    * ``ctrl+n``  - Switch to next buffer
    * ``ctrl+p``  - Switch to previous buffer
    * ``alt+a`` - Switch to buffer with activity
    * ``alt+0..9`` - Switch to buffer
    * ``F9/F10``  - Scroll buffer title
    * ``F11/F12``  - Scroll nick list
    * ``ctrl+r`` - Search
        * Enter, ``ctrl+j``, ``ctrl+m``  - Stop search
    * ``alt+=`` -  Disabled filters (hide/join) (``alt+-`` for current buffer)
        * ``/filter add irc_smart * irc_smart_filter *``  - Smart hide/join/filter
    * ``alt+t`` -  Toggle nick list
        * ``/key bind meta-t /bar toggle nicklist``
    * ``/mob`` - Mobile layout
    * ``/desk`` - Desktop layout
* **sxiv**
    * ``ctrl+x`` and:
        * ``e`` - Edit in the Gimp
        * ``r`` - Rotate 90 degrees clockwise
        * ``R`` - Rotate 90 degrees clockwise
        * ``d`` - Delete (asks confirmation)
        * ``n`` - Copy to nettmp
        * ``t`` - Copy to shared/transfer
        * ``T`` - Copy to /tmp


