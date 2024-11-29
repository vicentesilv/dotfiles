#!/bin/bash

###########################
#   autor vicente silva   #
###########################

if [ "$(whoami)" == "root" ]; then
  exit 1
fi

ruta = $(pwd)
###########################
#actualizacion del sistema#
###########################

echo "actualizacion del sistema"
sudo apt update
echo "instalacion de dependencias"
sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev
sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev
sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev
sudo apt install -y feh flameshot scrub zsh rofi xclip bat locate neofetch wmname acpi bspwm sxhkd imagemagick ranger kitty

echo "descargando polybar y picom"
mkdir ~/github
cd ~/github
git clone --recursive https://github.com/polybar/polybar
git clone https://github.com/ibhagwan/picom.git

#instalacion de polybar
cd ~/github/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

#instalacion de picom
cd ~/github/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

#instalacion de pk10 configuracion zsh/ssh
echo "instalacion de tema visual de la terminal"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Instalando p10k root
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k

#configuracion de algunos comandos personalizados
echo '
alias xamp="sudo /opt/lampp/manager-linux-x64.run"
alias xamprestart="sudo /opt/lampp/./xampp restart"
alias xamptart="sudo /opt/lampp/./xampp start"
alias xamptop="sudo /opt/lampp/./xampp stop"
alias stop="sudo systemctl stop mysql.service && sudo systemctl stop apache2.service"
alias start="sudo systemctl start mysql.service && sudo systemctl start apache2.service"

alias nvim="/opt/nvim/nvim.appimage"' >>~/.zshrc

#configuracion de rofi

echo "instalacion de nvim"
cp -r $ruta/nvim /opt

#configuracion de rofi
echo "configuracion de rofi"
cp -r $ruta/configs/rofi ~/.config

sudo dpkg -i $ruta/lsd.deb

sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/
sudo cp -v $ruta/Config/polybar/fonts/* /usr/share/fonts/truetype/

mkdir ~/wallpapers
cp -v $ruta/wallpapers/* ~/wallpapers

cp -rv $ruta/Config/* ~/.config/
sudo cp -rv $ruta/kitty /opt/

# Kitty Root

sudo cp -rv $ruta/Config/kitty /root/.config/

# Copia de configuracion de .p10k.zsh y .zshrc

rm -rf ~/.zshrc
cp -v $ruta/.zshrc ~/.zshrc

cp -v $ruta/.p10k.zsh ~/.p10k.zsh
sudo cp -v $ruta/.p10k.zsh-root /root/.p10k.zsh

# Script

sudo cp -v $ruta/scripts/whichSystem.py /usr/local/bin/
sudo cp -v $ruta/scripts/screenshot /usr/local/bin/

# Plugins ZSH

sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions zsh-autocomplete
sudo mkdir /usr/share/zsh-sudo
cd /usr/share/zsh-sudo
sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Cambiando de SHELL a zsh

chsh -s /usr/bin/zsh
sudo usermod --shell /usr/bin/zsh root
sudo ln -s -fv ~/.zshrc /root/.zshrc

# Asignamos Permisos a los Scritps

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/scripts/bspwm_resize
chmod +x ~/.config/bin/ethernet_status.sh
chmod +x ~/.config/bin/htb_status.sh
chmod +x ~/.config/bin/htb_target.sh
chmod +x ~/.config/polybar/launch.sh
sudo chmod +x /usr/local/bin/whichSystem.py

rm -rf ~/github
rm -rf $ruta

# Mensaje de Instalado

notify-send "instalacion de entorno completada"
