#!/bin/bash

# Ocultar cursor al inicio
tput civis

# Restaurar cursor si el script se interrumpe o falla
trap 'tput cnorm; exit' INT TERM EXIT

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


if [ "$(id -u)" -eq 0 ]; then
    echo -e "${redColour}[!]${endColour} No ejecutes este script como root"
    tput cnorm
    exit 1
fi

ruta=$(pwd)

if [ "$TERM" != "xterm-kitty" ]; then
    echo -e "Please install the kitty terminal and run this script inside it.\n"
    echo -e "You can install it by running:\n"
    echo -e "${greenColour}sudo apt install kitty${endColour}\n"
    tput cnorm
    exit 1
fi


# Instalar paquetes
echo -e "${yellowColour}[*]${endColour} Installing required packages...\n"
sudo apt install -y build-essential rofi git vim xcb libxcb-util0-dev libxcb-xinerama0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev &> /dev/null

mkdir -p ~/github

# Clonar repositorios
echo -e "${yellowColour}[*]${endColour} Cloning required repositories...\n"
cd ~/github
git clone https://github.com/baskerville/bspwm.git &> /dev/null
git clone https://github.com/baskerville/sxhkd.git &> /dev/null
cd bspwm/
make &> /dev/null
sudo make install &> /dev/null
cd ../sxhkd/ 
make &> /dev/null
sudo make install &> /dev/null
sudo apt install -y bspwm &> /dev/null

# Cargar repositorios
echo -e "${yellowColour}[*]${endColour} Creating configuration files...\n"
sudo apt install -y bspwm &> /dev/null
mkdir -p ~/.config/bspwm
mkdir -p ~/.config/sxhkd
cd ~/github/bspwm/
cp "$ruta/config/bspwmrc" ~/.config/bspwm/
chmod +x ~/.config/bspwm/bspwmrc 
cp "$ruta/config/sxhkdrc" ~/.config/sxhkd/

# Instalar polybar
echo -e "${yellowColour}[*]${endColour} Installing polybar...\n"
sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev &> /dev/null

cd /home/$USER/Downloads/
git clone --recursive https://github.com/polybar/polybar &> /dev/null
cd polybar/
mkdir build
cd build/
cmake .. &> /dev/null
make -j$(nproc) &> /dev/null
sudo make install &> /dev/null

# Configurar polybar
echo -e "${yellowColour}[*]${endColour} Copying configuration files for polybar...\n"
sudo apt update -y
sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev -y &> /dev/null
cd /home/$USER/Downloads/
git clone https://github.com/ibhagwan/picom.git &> /dev/null
cd picom/
git submodule update --init --recursive &> /dev/null
meson --buildtype=release . build  &> /dev/null
ninja -C build &> /dev/null
sudo ninja -C build install &> /dev/null

# Despliegue de polybar
echo -e "${yellowColour}[*]${endColour} Deploying polybar...\n"
cd /home/$USER/Downloads/
git clone https://github.com/VaughnValle/blue-sky.git &> /dev/null
mkdir -p ~/.config/polybar
cd blue-sky/polybar/   
cp * -r ~/.config/polybar &> /dev/null
echo "~/.config/polybar/launch.sh" >> ~/.config/bspwm/bspwmrc &> /dev/null
cd fonts/
sudo cp * /usr/share/fonts/truetype/ &> /dev/null
fc-cache -v &> /dev/null


echo -e "The end of the installation script has been reached.\n"

# Restaurar cursor al finalizar
tput cnorm
