#!/bin/bash

# Made by d4rkonus

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

ruta=$(pwd) 

# Check the kitty terminal
check_kitty_terminal(){
    if [ "$TERM" != "xterm-kitty" ]; then
        echo -e "${redColour}[!] Please, run this script in the Kitty terminal.${endColour}"
        exit 1
    fi
}

# Check the user
check_root_user(){
    if [ "$EUID" -ne 0 ]; then
        echo -e "${redColour}[!] Please, run this script as Root User.${endColour}"
        exit 1
    fi
}

# Update the system
update_system(){
    echo -e "${blueColour}[+] Updating system...${endColour}"
    apt update -y >/dev/null 2>&1 && apt upgrade -y >/dev/null 2>&1
    echo -e "${greenColour}[✓] System upgrades checked.${endColour}\n"
}

# Install dependencies
install_dependencies(){
    echo -e "${blueColour}[+] Installing dependencies...${endColour}"
    apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev feh scrot scrub rofi xclip bat locate ranger neofetch wmname acpi sxhkd imagemagick >/dev/null 2>&1
    echo -e "${greenColour}[✓] Dependencies installed.${endColour}\n"
}

# 

# Cloning repositories
clone_repositories(){
    echo -e "${blueColour}[+] Cloning repositories...${endColour}"
    mkdir -p ~/github >/dev/null 2>&1 || {
        echo -e "${redColour}[!] Error: Could not create github directory${endColour}"
        return 1
    }
    cd ~/github >/dev/null 2>&1 || return 1
    echo -e "${yellowColour}[*] Cloning polybar...${endColour}"
    git clone --recursive https://github.com/polybar/polybar >/dev/null 2>&1 || {
        echo -e "${redColour}[!] Error: Could not clone polybar${endColour}"
        return 1
    }
    echo -e "${yellowColour}[*] Cloning picom...${endColour}"
    git clone https://github.com/ibhagwan/picom.git >/dev/null 2>&1 || {
        echo -e "${redColour}[!] Error: Could not clone picom${endColour}"
        return 1
    }
    echo -e "${greenColour}[✓] Repositories cloned successfully${endColour}\n"
}

# Install polybar
install_polybar(){
    echo -e "${blueColour}[+] Installing polybar...${endColour}"
    cd ~/github/polybar >/dev/null 2>&1 || {
        echo -e "${redColour}[!] Error: Could not access polybar directory${endColour}"
        return 1
    }
    mkdir -p build >/dev/null 2>&1
    cd build >/dev/null 2>&1 || return 1
    echo -e "${yellowColour}[*] Configuring with cmake...${endColour}"
    cmake .. >/dev/null 2>&1
    echo -e "${yellowColour}[*] Building polybar...${endColour}"
    make -j$(nproc) >/dev/null 2>&1
    echo -e "${yellowColour}[*] Installing polybar...${endColour}"
    sudo make install >/dev/null 2>&1
    echo -e "${greenColour}[✓] Polybar installed successfully${endColour}\n"
}

# Install picom
install_picom(){
    echo -e "${blueColour}[+] Installing picom...${endColour}"
    cd ~/github/picom >/dev/null 2>&1 || {
        echo -e "${redColour}[!] Error: Could not access picom directory${endColour}"
        return 1
    }
    git submodule update --init --recursive >/dev/null 2>&1
    meson --buildtype=release . build >/dev/null 2>&1
    ninja -C build >/dev/null 2>&1
    sudo ninja -C build install >/dev/null 2>&1
    echo -e "${greenColour}[✓] Picom installed successfully${endColour}\n"
}

# Add kitty files
kitty_files(){
    echo -e "${blueColour}[+] Adding kitty configuration files...${endColour}"
    mkdir -p ~/.config/kitty >/dev/null 2>&1
    cp $ruta/kitty/kitty.conf ~/.config/kitty/kitty.conf >/dev/null 2>&1
    cp $ruta/kitty/color.ini ~/.config/kitty/color.ini >/dev/null 2>&1
    echo -e "${greenColour}[✓] Kitty configuration files added.${endColour}\n"
}

check_kitty_terminal
check_root_user
update_system
install_dependencies
clone_repositories
install_polybar
install_picom
kitty_files

