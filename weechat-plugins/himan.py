# Hi, man! and its versions are (c) 2019 by pX <@havok.org> (in #pX on EFNet)
# (extended by proycon to add notifications)
# Hi, man! was written under GPL3 license.  http://gnu.org/licenses
# The gist of the licnse: use and/or modify at your own risk!
#
# Hi, man!  What have they been saying about you?
# Log highlights to a private buffer while /away (or not!)
# Hi, man! relies on words in weechat.look.highlight
# https://github.com/px-havok/weechat-himan
#
# I wrote this because my good pal narcolept wanted a highmon.pl
# that looked good with fUrlbuf (https://github.com/px-havok/weechat-furlbuf)
#
# Hi narcolept!
#
# History:
#   04.09.2019:
#       v0.1: Initial release, py3-ok
#   04.11.2019:
#           : Added 'notify' as an option
#           : Added hook_config so don't have to reload script for changes.

import os
from time import time

try:
    import weechat as w
except Exception:
    print('WeeChat (https://weechat.org/) required.')
    quit()


SCRIPT_NAME     = 'himan'
SCRIPT_AUTHOR   = 'pX @ havok, proycon'
SCRIPT_VERSION  = '0.2'
SCRIPT_LICENSE  = 'GPL3'
SCRIPT_DESC     = "What have they been saying about you?"

OPTIONS         = {'buffer_color'        : ("magenta", 'color of buffer name'),
                   'nick_color'          : ("green", 'color of mentioners nick'),
                   'nick_blacklist'      : ("gitlama,f00f", 'comma separated list of nicks to ignore, case insensitive'),
                   'buffer_blacklist'    : ("gitlama", 'comma separated list of buffers to ignore, case insensitive'),
                   'notify'              : ("off", 'highlight (notify) buffer if written to'),
                   'only_away'           : ("on", 'only log highlights while /away'),
                   'outp_left'           : ("<", 'character(s) left of nick'),
                   'outp_left_color'     : ("gray", 'color of character(s) left of nick'),
                   'outp_right'          : (">", 'character(s) right of buffer name'),
                   'outp_right_color'    : ("gray", 'color of character(s) right of nick'),
                   'outp_sep'            : ("@", 'nick/buffer separator(s)'),
                   'outp_sep_color'      : ("gray", 'color of <nick> / buffer separator(s)'),
                  }

global rst
rst = w.color('reset')
lastchime = 0

# ================================[ item ]===============================
def c(color):
    return w.color(color)


def cg(option):
    return w.config_get_plugin(option)


def himan_buffer_create():

    global himan_buffer
    himan_buffer = w.buffer_new('himan', 'himan_input_cb', '', '', '')
    w.buffer_set(himan_buffer, 'title', '-[Hi, man! v' + SCRIPT_VERSION + ']- ' + SCRIPT_DESC)
    w.buffer_set(himan_buffer, 'nicklist', '0')

    # configurable option to set buffer notify on or off
    w.buffer_set(himan_buffer, 'notify', '0')
    if cg('notify') == 'on':
        w.buffer_set(himan_buffer, 'notify', '1')


def checker(data, buffer, date, tags, displayed, highlight, prefix, message):
    global lastchime

    # Do nothing if no highlight words set
    if w.config_get('weechat.look.highlight') == '':
        return w.WEECHAT_RC_OK

    # if away logging is on but you're not away, do nothing
    if cg('only_away') == 'on' and not w.buffer_get_string(buffer, 'localvar_away'):
        return w.WEECHAT_RC_OK

    if int(highlight):

        tags = tags.split(',')
        nick = nick_colored = ''
        for idx in range(len(tags)):
            if 'nick_' in tags[idx]:
                nick = tags[idx][5:]
                nick_colored = c(cg('nick_color')) + tags[idx][5:] + rst

        buffername = w.buffer_get_string(buffer, 'short_name')

        if nick.lower() in [ x.strip().lower() for x in cg('nick_blacklist').split(',') ] or buffername.lower() in [ x.strip().lower() for x in cg('buffer_blacklist').split(',') ]:
            return w.WEECHAT_RC_OK

        outp_left = c(cg('outp_left_color')) + cg('outp_left') + rst
        outp_right = c(cg('outp_right_color')) + cg('outp_right') + rst
        outp_sep = c(cg('outp_sep_color')) + cg('outp_sep') + rst
        buffername_colored = c(cg('buffer_color')) + buffername + rst
        sp = ' '
        # account for ACTION (/me)
        if '*' in prefix:
            sp = ' * '

        if not w.buffer_search('python', 'himan'):
            himan_buffer_create()

        w.prnt(himan_buffer, outp_left + nick_colored + outp_sep + buffername_colored + outp_right + sp + message)

        if not (message.startswith("[") and len(message) >= 10 and message[9] == "]"): #this is likely a timestamp from ZNC, we don't notify for those
            os.system(f"notify-send -t \"{nick}@{buffername}\" \"{message}\"")
            if int(time.time()) - lastchime > 10:
                os.system(f"mpv --no-video ~/dotfiles/media/chime.wav &")
                lastchime = int(time.time())

    return w.WEECHAT_RC_OK


# ===================[ weechat options & description ]===================
def init_options():
    for option,value in list(OPTIONS.items()):
        if not w.config_is_set_plugin(option):
            w.config_set_plugin(option, value[0])
            OPTIONS[option] = value[0]
        else:
            OPTIONS[option] = w.config_get_plugin(option)
        w.config_set_desc_plugin(option,'%s (default: "%s")' % (value[1], value[0]))


# dummy input bar, does nothing.
def himan_input_cb(data, buffer, input_data):
    return w.WEECHAT_RC_OK


def timer_cb(data, remaining_calls):
    w.prnt(w.current_buffer(), '%s' % data)
    return w.WEECHAT_RC_OK


# if notify option changes, update without reloading
def notify_cb(data, option, value):
    option = cg('notify')
    if option == 'on':
        w.buffer_set(himan_buffer, 'notify', '1')
    elif option == 'off':
        w.buffer_set(himan_buffer, 'notify', '0')
    return w.WEECHAT_RC_OK


def shutdown_cb():
    global himan_buffer
    himan_buffer = None
    return w.WEECHAT_RC_OK


# ================================[ main ]===============================
if __name__ == '__main__':
    if w.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, 'shutdown_cb', ''):

        init_options()

        himan_buffer_create()

        w.hook_timer(2000, 0, 1, 'timer_cb', '[himan]\tHi, man!  What are they saying about you?\n'
                            '[himan]\tHighlights will be logged to "himan" buffer\n'
                            '[himan]\tOptions: /fset himan')

        w.hook_config("plugins.var.python." + SCRIPT_NAME + ".notify", "notify_cb", "")

        w.hook_print('', 'notify_message', '', 0, 'checker', '')
