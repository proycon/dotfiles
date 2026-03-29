#!/usr/bin/env python3

import os
import threading
import sys
import io
import signal
import re
import time

import subprocess
from PIL import Image, ImageDraw, ImageFont
from StreamDeck.DeviceManager import DeviceManager
from StreamDeck.Devices.StreamDeck import DialEventType, TouchscreenEventType, StreamDeck as Deck
from StreamDeck.Transport.Transport import TransportError

ASSETS_PATH = os.path.join(os.path.dirname(__file__), "../media/icons")
IMAGES = ['muted','unmuted','play','stopmusic', 'next', 'pause', 'screenshot', 'videocam', 'novideocam','vpn','novpn']
FONT = ImageFont.truetype("/usr/share/fonts/TTF/UbuntuNerdFont-Regular.ttf", 42, encoding="unic")

class Timer(threading.Timer):
    def run(self):
        while not self.finished.wait(self.interval):
            self.function(*self.args, **self.kwargs)


class Key():
    POLL_INTERVAL = 1
    def __init__(self, index: int):
        self.index = index
        self.last_img = None

    def load(self, deck: Deck, images: dict):
        self.images = images

    def pressed(self, deck: Deck):
        pass

    def poll(self, deck: Deck):
        pass

class MuteKey(Key):
    POLL_INTERVAL = 1

    def load(self, deck: Deck, images: dict):
        super().load(deck, images)
        muted = subprocess.call(f"wpctl get-volume @DEFAULT_SINK@ | grep MUTED",shell=True) == 0
        self.set_image(deck, muted)

    def pressed(self, deck: Deck):
        muted = toggle_mute()
        self.set_image(deck, muted)

    def set_image(self, deck: Deck, muted: bool):
        if muted and self.last_img != 'muted':
            deck.set_key_image(self.index, self.images['muted'])
            self.last_image = 'muted'
        elif not muted and self.last_img != 'unmuted':
            deck.set_key_image(self.index, self.images['unmuted'])
            self.last_image = 'unmuted'

    def poll(self, deck: Deck):
        muted = subprocess.call(f"wpctl get-volume @DEFAULT_SINK@ | grep MUTED",shell=True) == 0
        self.set_image(deck, muted)

class ProcessCommandKey(Key):
    POLL_INTERVAL = 5

    def __init__(self, index: int, process_name: str, cmd_turn_on: str, cmd_turn_off: str, img_turn_on: str, img_turn_off: str, pgrep_opts: str = ""):
        super().__init__(index)
        self.process_name = process_name
        self.cmd_turn_on = cmd_turn_on
        self.cmd_turn_off = cmd_turn_off
        self.img_turn_on = img_turn_on
        self.img_turn_off = img_turn_off
        self.pgrep_opts = pgrep_opts

    def load(self, deck: Deck, images: dict):
        super().load(deck,images)
        self.set_image(deck)

    def set_image(self, deck: Deck):
        if subprocess.call(f"pgrep {self.pgrep_opts} \"{self.process_name}\"", shell=True) != 0:
            if self.last_img != self.img_turn_on:
                deck.set_key_image(self.index, self.images[self.img_turn_on])
                self.last_img = self.img_turn_on
        else:
            if self.last_img != self.img_turn_off:
                deck.set_key_image(self.index, self.images[self.img_turn_off])
                self.last_img = self.img_turn_off

    def pressed(self, deck: Deck):
        if subprocess.call(f"pgrep {self.pgrep_opts} \"{self.process_name}\"", shell=True) != 0:
            subprocess.call(f"{self.cmd_turn_on} &", shell=True)
            deck.set_key_image(self.index, self.images[self.img_turn_off])
            self.last_img = self.img_turn_off
        else:
            subprocess.call(self.cmd_turn_off, shell=True)
            deck.set_key_image(self.index, self.images[self.img_turn_on])
            self.last_img = self.img_turn_on

    def poll(self, deck: Deck):
        self.set_image(deck)

class CommandKey(Key):
    def __init__(self, index: int,  cmd: str, img: str):
        super().__init__(index)
        self.cmd = cmd
        self.img = img
        self.last_img = None

    def load(self, deck: Deck, images: dict):
        super().load(deck,images)
        self.set_image(deck)

    def set_image(self, deck: Deck):
        deck.set_key_image(self.index, self.images[self.img])

    def pressed(self, deck: Deck):
        subprocess.call(f"{self.cmd} &", shell=True)


KEYS = {
    0: ProcessCommandKey(0, "openfortivpn", "sudo vpn-knaw.sh","sudo pkill openfortivpn", "novpn","vpn"),
    1: CommandKey(1, "~/dotfiles/scripts/screenshot.sh region","screenshot"),
    2: ProcessCommandKey(2, "snapclient", "lala","pkill snapclient && mpc stop", "play","stopmusic"),
    3: CommandKey(3, "mpc pause-if-playing || mpc play","pause"),
    5: ProcessCommandKey(5, "mpv rtsp",  "~/bin/streetcam.sh","pkill -f \"mpv rtsp\"","videocam", "novideocam", "-f"),
    6: CommandKey(6, "mpc next","next"),
    7: MuteKey(7)
}

def load_img(images: dict, name: str):
    img = Image.new('RGB', (120, 120), color='black')
    released_icon = Image.open(os.path.join(ASSETS_PATH, f"{name}.png")).resize((80, 80))
    img.paste(released_icon, (20, 20), released_icon)
    img_byte_arr = io.BytesIO()
    img.save(img_byte_arr, format='JPEG')
    images[name] = img_byte_arr.getvalue()


# callback when buttons are pressed or released
def key_change_callback(deck, key, key_state):
    print("Key: " + str(key) + " state: " + str(key_state), file=sys.stderr)
    if key_state:
        KEYS[key].pressed(deck)

def dial_change_callback(deck, dial, event, value):
    if dial == 0:
        if event == DialEventType.PUSH and value is True:
            subprocess.call(f"wtype -k Return",shell=True)
        elif event == DialEventType.TURN:
            if value > 0:
                for _ in range(0,value):
                    subprocess.call(f"wtype -k Down",shell=True)
            elif value < 0:
                for _ in range(0,value * -1):
                    subprocess.call(f"wtype -k Up",shell=True)
    elif dial == 3:
        if event == DialEventType.PUSH and value is True:
            KEYS[7].pressed(deck)
            subprocess.call(f"kill -34 $(pgrep -x bar.sh)",shell=True)
            build_screen(deck)
        elif event == DialEventType.TURN:
            try:
                set_volume(value)
                build_screen(deck)
            except Exception as e:
                print(e, file=sys.stderr)

# callback when lcd is touched
def touchscreen_event_callback(deck, evt_type, value):
    if evt_type == TouchscreenEventType.SHORT:
        print("Short touch @ " + str(value['x']) + "," + str(value['y']))
    elif evt_type == TouchscreenEventType.LONG:
        print("Long touch @ " + str(value['x']) + "," + str(value['y']))
    elif evt_type == TouchscreenEventType.DRAG:
        print("Drag started @ " + str(value['x']) + "," + str(value['y']) + " ended @ " + str(value['x_out']) + "," + str(value['y_out']))


def set_volume(increase: int):
    if increase >= 0:
        subprocess.call(f"wpctl set-volume @DEFAULT_SINK@ 0.0{increase}+ && kill -34 $(pgrep -x bar.sh)",shell=True)
    else:
        subprocess.call(f"wpctl set-volume @DEFAULT_SINK@ 0.0{abs(increase)}- && kill -34 $(pgrep -x bar.sh)",shell=True)

def toggle_mute() -> bool:
    muted = subprocess.call(f"wpctl set-mute @DEFAULT_SINK@ toggle && wpctl get-volume @DEFAULT_SINK@ | grep MUTED", shell=True) == 0
    subprocess.call("kill -34 $(pgrep -x bar.sh)", shell=True)
    return muted


def signal_handler(deck):

    def handler(signum, frame):
        print("Got kill signal", file=sys.stderr)
        for t in threading.enumerate():
            if hasattr(t,'cancel'):
                print("Cancelling a thread", file=sys.stderr)
                t.cancel()
        print("Resetting the deck", file=sys.stderr)
        deck.reset()
        sys.exit(0)

    return handler

def build_screen(deck):
    with open(os.path.join(os.environ['XDG_RUNTIME_DIR'], "bar.out"), 'r', encoding='utf-8') as f:
        text = f.read()

    if text != deck.prevtext:
        deck.prevtext = text
        img = Image.new('RGB', (800, 100), 'black')
        draw = ImageDraw.Draw(img)

        pattern = r"\^\#(?:[0-9a-fA-F]{8}|!)"
        monotext = re.sub(pattern, "", text)
        draw.text((5,5), monotext, 'white', FONT)

        img_bytes = io.BytesIO()
        img.save(img_bytes, format='JPEG')
        deck.set_touchscreen_image(img_bytes.getvalue(), 0, 0, 800, 100)

def main():
    images = {}

    for image in IMAGES:
        load_img(images, image)

    streamdecks = DeviceManager().enumerate()

    print("Found {} Stream Deck(s).\n".format(len(streamdecks)))

    for _, deck in enumerate(streamdecks):
        # This example only works with devices that have screens.

        if deck.DECK_TYPE != 'Stream Deck +':
            print(deck.DECK_TYPE)
            print("Sorry, this only works with Stream Deck +")
            continue


        try:
            deck.open()
            deck.reset()
        except Exception as e:
            print("Unable to open device (other process in use or hard reset required?): ", e)
            sys.exit(1)

        signal.signal(signal.SIGINT, signal_handler(deck))
        signal.signal(signal.SIGTERM, signal_handler(deck))

        deck.set_key_callback(key_change_callback)
        deck.set_dial_callback(dial_change_callback)
        deck.set_touchscreen_callback(touchscreen_event_callback)

        print("Opened '{}' device (serial number: '{}')".format(deck.deck_type(), deck.get_serial_number()))

        # Set initial screen brightness to 30%.
        deck.set_brightness(100)

        setattr(deck, 'prevtext', "")

        Timer(2, lambda x: build_screen(x), [deck]).start()
        for key in KEYS.values():
            key.load(deck, images)
            Timer( float(key.POLL_INTERVAL), key.poll, [deck]).start()

        while threading.active_count() <= len(KEYS) + 1:
            print("Waiting for all threads to become alive", file=sys.stderr)
            time.sleep(1)

        # Wait until all application threads have terminated (for this example,
        # this is when all deck handles are closed).
        for i, t in enumerate(threading.enumerate()):
            if i > 0: #first thread is main thread and can not join itself
                try:
                    t.join()
                except (TransportError, RuntimeError) as e:
                    print(f"#{i} Error waiting for join: {e}", file=sys.stderr)
                    break

    print("Exiting cleanly", file=sys.stderr)


if __name__ == "__main__":
    main()
