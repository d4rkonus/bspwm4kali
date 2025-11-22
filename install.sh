#!/bin/bash

tput civis
trap 'tput cnorm; exit' INT TERM EXIT

install_dependencies() {
    echo -e "\n[+] Instalando dependencias..."
    sudo apt-get install -y \
        build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
        libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev \
        libxcb-xtest0-dev libxcb-shape0-dev make cmake cmake-data pkg-config python3-sphinx \
        libcairo2-dev libxcb1-dev libxcb-composite0-dev python3-xcbgen xcb-proto \
        libxcb-image0-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libpulse-dev \
        libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev meson libxext-dev \
        libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev \
        libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 \
        libpcre3-dev feh scrot scrub rofi xclip bat locate ranger wmname acpi bspwm \
        sxhkd imagemagick > /dev/null
}

import_repositories(){
    echo -e "\n[+] Clonando repositorios..."
    mkdir -p ~/testing
    cd ~/testing
    git clone --recursive https://github.com/polybar/polybar 2>/dev/null
    git clone https://github.com/ibhagwan/picom.git 2>/dev/null
}

install_polybar(){
    echo -e "\n[+] Instalando Polybar..."
    cd ~/testing/polybar 
    mkdir build
    cd build 
    cmake .. -DBUILD_DOC=OFF -Wno-dev >/dev/null 2>&1
    sudo make install >/dev/null
}

finally(){
    echo "[$] Script finished."
}


install_dependencies
import_repositories
install_polybar
finally

tput cnorm
