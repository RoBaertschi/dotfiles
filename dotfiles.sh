#!/usr/bin/env bash

set -ex

link() {
    local from=${PWD}/$1
    local to=$2
    if [[ -L "${to}" ]]; then
        return
    fi

    if [[ -d "${to}" ]]; then
        rm -r "${to}"
    fi

    if [[ -f "${to}" ]]; then
        rm "${to}"
    fi

    ln -s "${from}" "${to}"
}

mkdir -p ~/.config

link foot ~/.config/foot
link sway ~/.config/sway
link waybar ~/.config/waybar
link niri ~/.config/niri

link emacs/.emacs ~/.emacs
link emacs/.emacs.d/odin-mode.el ~/.emacs.d/odin-mode.el
link emacs/.emacs.d/simpc-mode.el ~/.emacs.d/simpc-mode.el
