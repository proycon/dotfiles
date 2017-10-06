My dotfiles
================

![](screenshot.jpg?raw=true)

Software
------------

Current setup:

* **OS**: Arch Linux
* **Window Manager**: [i3-gaps](https://github.com/Airblader/i3)
* **Bar**: [polybar](https://github.com/jaagr/polybar)
* **Shell**: zsh
* **Terminal:** urxvt
* **Terminal Multiplexer**: tmux
* **Editor**: neovim
* **Browser**: firefox
* **Music player**: ncmpcpp + mopidy
* **Mail**: alot
* **Chat**: weechat + bitblee (IRC+XMPP+Twitter+Telegram+Discord)

Key bindings
--------------

* **i3**
    * ``cmd+',1,2,3,4,5,6,7,8,9,0,-,=`` - switch workspaces *(entire top key row, 13 workspaces)*
        * On multihead setups, odd numbers are left monitor, even numbers right monitor
    * ``cmd+Shift+',1,2,3,4,5,6,7,8,9,0,-,=`` - move window to selected workspaces
    * ``cmd+tab`` - Switch to last used workspace (and back)
    * ``cmd+left/right/up/down`` or ``cmd+h/j/k/l``- Switch window focus
    * ``cmd+enter`` or ``cmd+t`` - New terminal (urxvt)
    * ``cmd+space`` - Launcher (rofi)
    * ``cmd+x`` - Execution mode
        * ``m`` - Connect to mail and chat (remote tmux)
        * ``v`` - Connect to editor tmux
        * ``g`` - Image viewer (geeqie)
        * ``f`` - File manager (pcmanfm)
        * ``w`` - Web browser (firefox)
        * ``M`` - Music player (ncmpcpp)
    * ``cmd+r`` - Resize mode
    * ``cmd+shift+c`` - Reload configuration
    * ``cmd+shift+q`` - Close window
    * ``cmd+shift+e`` - Exit
    * Layouts
        * ``cmd+w`` - Tabbed layout
        * ``cmd+s`` - Stacked layout
        * ``cmd+e`` - Split layout (toggles orientation too)
        * ``cmd+f`` - Fullscreen
        * ``cmd+Shift+space`` - Toggle floating
        * ``cmd+/`` - Toggle tiling/floating
    * Keyboard input methods:
        * ``alt+F8`` - Simplified Chinese (fcitx)
        * ``alt+F9`` - Latin (default)
        * ``alt+F10`` - Esperanto
        * ``alt+F11`` - Russian
        * ``alt+F12`` - Arabic
        * ``alt+Shift+F9`` - Croatian/Serbian (Latin)
        * ``alt+Shift+F10`` - Greek
        * ``alt+Shift+F11`` - Serbian (Cyrillic)
* **tmux**
    * ``alt+left/right/up/down`` - Switch pane
    * ``alt+pageup/pagedown`` - Switch window
    * ``ctrl+a`` (prefix)
        * ``(number)`` - Switch window
        * ``c`` - New window
        * ``a`` or ``"`` - New pane (horizontal split)
        * ``e`` or ``%`` - New pane (vertical split)
        * ``ctrl+a`` - Switch to last window (and back)
        * ``;`` - Switch to last pane (and back)
        * ``space`` - Switch pane layout (cycles through a few), good for turning vertical panes horizontal and vice
          versa
        * ``,`` - Rename window
        * ``/`` - Flip/swap
        * ``x`` - Kill pane
        * ``z`` - zoom pane
        * ``!`` - Break pane (to its own window)
        * ``r`` - reload
        * ``v`` - copy mode
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
* **alot**



