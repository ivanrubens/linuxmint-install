#!/usr/bin/env bash

PROGRAMAS_SNAP_REMOVER=(
bare
core
core18
gnome-3-26-1604
gnome-3-28-1804
gtk-common-themes
gtk2-common-themes
mockoon
robo3t-snap
wine-platform-3-stable
wine-platform-5-stable
wine-platform-6-stable
wine-platform-runtime
)

for nome_do_programa in ${PROGRAMAS_SNAP_REMOVER[@]}; do
    sudo snap remove "$nome_do_programa"
done