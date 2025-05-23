#!/bin/bash

# bspwm_conf_desktops --- Configure monitor settings for BSPWM.
#
# Copyright (c) 2019-2024  Protesilaos Stavrou <info@protesilaos.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.	If not, see <https://www.gnu.org/licenses/>.

if [ "$(bspc query -M | wc -l)" -eq 2 ]; then
	# Set the workspaces per monitor.  We only define one per monitor,
	# because of another script I have that implements dynamic desktops.
	# For the XrandR settings see my `bspwm_conf_xrandr.sh'.
	bspc monitor DisplayPort-1 -d 1
	bspc monitor HDMI-A-0 -d 8

	# Make sure borders are always on, otherwise it is impossible to
	# find the focused window on two monitors with monocles…
	bspc config borderless_monocle false
else
	bspc monitor -d 1
fi
