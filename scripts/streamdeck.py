#!/usr/bin/env python3

import os
import threading
import sys
import io
import signal

import pulsectl
import subprocess
from PIL import Image
from StreamDeck.DeviceManager import DeviceManager
from StreamDeck.Devices.StreamDeck import DialEventType, TouchscreenEventType, StreamDeck as Deck
from StreamDeck.Transport.Transport import TransportError

ASSETS_PATH = os.path.join(os.path.dirname(__file__), "../media/icons")
IMAGES = ['muted','unmuted','play','stopmusic', 'next', 'pause', 'screenshot', 'videocam', 'novideocam','vpn','novpn']
PA = pulsectl.Pulse("volume-controller")

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
        pa = pulsectl.Pulse("volume-controller")
        sink = pa.sink_default_get()
        self.set_image(deck, sink.mute)

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
        pa = pulsectl.Pulse("volume-controller")
        sink = pa.sink_default_get()
        self.set_image(deck, sink.mute)

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
    if dial == 3:
        if event == DialEventType.PUSH and value is True:
            KEYS[7].pressed(deck)
        elif event == DialEventType.TURN:
            try:
                set_volume(value)
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
    #pa = pulsectl.Pulse("volume-controller")
    sink = PA.sink_default_get()
    new_volume: float = max(min(sink.volume.value_flat + (increase / 100.0), 1.0),0.0)
    sink.volume.value_flat = new_volume
    PA.volume_set(sink, sink.volume)
    print(f"Set volume {new_volume}")

def get_volume() -> float:
    #pa = pulsectl.Pulse("volume-controller")
    sink = PA.sink_default_get()
    return sink.volume.value_flat

def toggle_mute() -> bool:
    #pa = pulsectl.Pulse("volume-controller")
    # Get the default sink (audio output)
    sink = PA.sink_default_get()
    PA.mute(sink, not sink.mute)
    return sink.mute

def signal_handler(deck):
    """Handler for graceful shutdown on SIGINT"""

    def handler(signum, frame):
        for t in threading.enumerate():
            if hasattr(t,'cancel'):
                t.cancel()
        deck.reset()
        sys.exit(0)

    return handler

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

        deck.open()
        deck.reset()

        signal.signal(signal.SIGINT, signal_handler(deck))

        deck.set_key_callback(key_change_callback)
        deck.set_dial_callback(dial_change_callback)
        deck.set_touchscreen_callback(touchscreen_event_callback)

        print("Opened '{}' device (serial number: '{}')".format(deck.deck_type(), deck.get_serial_number()))

        # Set initial screen brightness to 30%.
        deck.set_brightness(100)

        for key in KEYS.values():
            key.load(deck, images)
            Timer( float(key.POLL_INTERVAL), key.poll, [deck]).start()


        # build an image for the touch lcd
        img = Image.new('RGB', (800, 100), 'black')
        #icon = Image.open(os.path.join(ASSETS_PATH, 'Exit.png')).resize((80, 80))
        #img.paste(icon, (690, 10), icon)

        #for dial in range(0, deck.DIAL_COUNT - 1):
        #    img.paste(released_icon, (30 + (dial * 220), 10), released_icon)

        #deck.set_touchscreen_image(touchscreen_image_bytes, 0, 0, 800, 100)

        # Wait until all application threads have terminated (for this example,
        # this is when all deck handles are closed).
        for t in threading.enumerate():
            try:
                t.join()
            except (TransportError, RuntimeError):
                pass

if __name__ == "__main__":
    main()
