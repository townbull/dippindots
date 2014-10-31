# https://github.com/sindresorhus/weechat-notification-center
# Requires `pip install pync`
# Author: Sindre Sorhus <sindresorhus@gmail.com>, Francis Tseng <f@frnsys.com>
# License: MIT

import weechat
from os import path
from pync import Notifier
from subprocess import Popen


SCRIPT_NAME = 'notification_center'
SCRIPT_AUTHOR = 'Sindre Sorhus <sindresorhus@gmail.com>, Francis Tseng <f@frnsys.com>'
SCRIPT_VERSION = '0.2.1'
SCRIPT_LICENSE = 'MIT'
SCRIPT_DESC = 'Pass highlights and private messages to the OS X 10.8+ Notification Center'

weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, '', '')

DEFAULT_OPTIONS = {
    'show_highlights': 'on',
    'show_private_message': 'on',
    'show_message_text': 'on',
    'notify_channels': '',
    'notify_sound': 'highlight,private', # can be none, all, or a combo of highlight,private,message
    'notify_soundfile': ''
}

for key, val in DEFAULT_OPTIONS.items():
    if not weechat.config_is_set_plugin(key):
        weechat.config_set_plugin(key, val)

weechat.hook_print('', 'irc_privmsg', '', 1, 'notify', '')

def notify(data, buffer, date, tags, displayed, highlight, prefix, message):
    soundfile = path.expanduser(weechat.config_get_plugin('notify_soundfile'))
    sound = weechat.config_get_plugin('notify_sound').split(',')
    
    channel = weechat.buffer_get_string(buffer, 'localvar_channel')
    nick = weechat.buffer_get_string(buffer, 'localvar_nick')
    notify_channels = weechat.config_get_plugin('notify_channels').split(',')
    
    if weechat.config_get_plugin('show_highlights') == 'on' and int(highlight):
        if weechat.config_get_plugin('show_message_text') == 'on':
            Notifier.notify(message, title='%s %s' % (prefix, channel))
        else:
            Notifier.notify('In %s by %s' % (channel, prefix), title='Highlighted Message')
        
        if 'all' in sound or 'highlight' in sound:
            Popen(['afplay', soundfile])


    elif weechat.config_get_plugin('show_private_message') == 'on' and 'notify_private' in tags:
        if weechat.config_get_plugin('show_message_text') == 'on':
            Notifier.notify(message, title='%s [private]' % prefix)
        else:
            Notifier.notify('From %s' % prefix, title='Private Message')

        if 'all' in sound or 'private' in sound:
            Popen(['afplay', soundfile])


    elif channel in notify_channels and prefix != nick:
        Notifier.notify(message, title='%s %s' % (prefix, channel))
        
        if 'all' in sound or 'message' in sound:
            Popen(['afplay', soundfile])

    return weechat.WEECHAT_RC_OK
