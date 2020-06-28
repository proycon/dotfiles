mkdir ~/src
cd ~/src
if [ ! -d "sxmo-dwm" ]; then
    git clone https://github.com/proycon/sxmo-dwm
fi
cd sxmo-dwm
cp -f config.def.h config.h
make && sudo rm /usr/bin/dwm && sudo cp dwm /usr/bin

cd -
if [ ! -d "sxmo-utils" ]; then
    git clone https://github.com/proycon/sxmo-utils
else
    git pull
fi
cd sxmo-utils
sudo make install

cd -
if [ ! -d "sxmo-svkbd" ]; then
    git clone https://github.com/proycon/sxmo-svkbd
else
    git pull
fi
cd sxmo-svkbd
cp -f config.def.h config.h
make && sudo cp svkbd-sxmo /usr/bin/
