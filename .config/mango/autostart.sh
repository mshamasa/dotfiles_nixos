#!/bin/env bash

waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css >/dev/null 2>&1 &
swaybg -i ~/walls/chaos.png >/dev/null 2>&1 &
