#!/usr/bin/env bash

set -ex

install_portage_file() {
    name=$1
    dir=$(dirname /etc/portage/$name)
    doas mkdir -p $dir
    doas cp ./portage/$name /etc/portage/$name
}

mkdir -p ~/.config

rm -r ~/.config/foot
cp -r ./foot/ ~/.config/foot
rm -r ~/.config/sway
cp -r ./sway/ ~/.config/sway
rm -r ~/.config/waybar
cp -r ./waybar/ ~/.config/waybar

rm ~/.emacs
cp ./emacs/.emacs ~/.emacs
rm -r ~/.emacs.d
cp -r ./emacs/.emacs.d ~/.emacs.d

install_portage_file package.use/rob-desktop
install_portage_file package.accept_keywords/rob-desktop
install_portage_file sets/rob-desktop

repo() {
    local name=$1
    doas eselect repository enable $name
    doas emerge --sync $name
}

doas emerge -av -1 --noreplace app-eselect/eselect-repository
repo gentoo-zh
repo wayland-desktop

install_portage_file sets/rob-desktop
doas emerge -av @rob-desktop --noreplace

service() {
    local name=$1
    doas rc-update add $name default
    doas rc-service $name start
}

user_service() {
    local name=$1
    rc-update add -U $name default
    rc-service -U $name start
}

user_service wireplumber
user_service pipewire-pulse
