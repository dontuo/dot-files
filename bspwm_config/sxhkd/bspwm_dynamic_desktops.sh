
#!/bin/bash

# bspwm_dynamic_desktops --- Dynamic desktops (work spaces) for BSPWM.
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
## Commentary:
#
# The idea with dynamic desktops is to maintain a list of varying
# lengths with only the active items.  Whereas the default is to keep a
# fixed list of, say, ten desktops at all times.
#
# What this script does, in outline:
#
# - Switching to a non-existent desktop will create it dynamically.
# - Sending a node to a given desktop will create that desktop as well.
#   - There also exists a variant that follows the node to that desktop.
# - Empty desktops are removed.
#
# Furthermore, there exists a toggle for multi-head setups (typically
# dual-monitor) which allows us to bind desktops to monitors, while
# retaining the aforementioned patterns of behaviour.  In practice this
# means that the relevant commands become agnostic to the focused
# monitor so that, e.g., switching to desktop 1 will always take you to
# desktop 1 which belongs to monitor A.
#
# This script's commands are meant to be implemented in SXHKD (or
# equivalent).  Furthermore, the desktops need to be set to one per
# monitor in bspwmrc (empty desktops are removed upon invoking one of
# this script's commands).
#
# `bspwm_dynamic_desktops.sh' is part of my dotfiles (which also offer a
# complete implementation): https://github.com/protesilaos/dotfiles



# See the --options below for the available arguments for $1.  $2 must
# be a number from 0 to 9.
[ "$#" -eq 2 ] || { echo 'Must be run with two arguments.'; exit 1; }

# Capture the arguments.  We need to run tests against them.  Renaming
# them makes things easier to read.
option="${*:1:1}"
target_desktop="${*:2:1}"

case "$target_desktop" in
    [!0-9])
        echo "The second argument must be a valid number"
        exit 1
        ;;
esac

# The `dynamic_but_dedicated' switch concerns multi-head setups
# (typically dual-monitor).  It allows us to specify a range of numbered
# desktops that we would want to always place on dedicated monitors.
# This means that while we retain the functionality of dynamically
# creating/removing desktops, we also bind certain desktops to monitors.
#
# NOTE: it only applies to the `--ns*' options (see the last part of the
# script).  As such, you can still send a node to any
# dynamically-created numbered desktop on the next monitor, by using the
# `--nm*' options.
if [ "$(bspc query -M | wc -l)" -gt 1 ]; then
    # Switch to `false' to restore the monitor-independent behaviour.
    dynamic_but_dedicated='true'
fi

# Here we specify the range of desktops that should always appear on the
# monitor named `LVDS-1'.  Everything else appears on `VGA-1'.  You can
# find the names of your monitors with `bspc query -M --names`.
#
# NOTE: if you use more that two monitors, you need to create another
# range similar to the one for LVDS-1 and adapt things accordingly.
if [ "$dynamic_but_dedicated" = 'true' ]; then
    dedicated_desktops='false'
    case "$target_desktop" in
        [1-8]) dedicated_monitor="DisplayPort-1" ;;
        *)     dedicated_monitor="HDMI-A-0"  ;;
    esac
fi

# Command for querying BSPWM desktops.  Used further below.
_query_desktops() {
    bspc query -D -d "$@"
}

# The core functionality of this script.  Behaviour changes based on
# whether this is a desktop or a node (each action is mapped to
# different key chords in sxhkd).
#
# If the target desktop does not exist, it is created on the spot.
_desk_or_node() {
    _dynamic_desktops() {
        # Here we make sure to clean up the arguments passed to this
        # function.  We can operate on them with greater flexibility.
        local monitor action
        monitor="${*:1:1}"
        action="${*:2}"

        # Leave the unquoted in tact!  Else the commands will not run.
        if ! _query_desktops "$target_desktop" > /dev/null; then
            bspc monitor "$monitor" -a "$target_desktop" && $action
        else
            # BACK-AND-FORTH behaviour: inputting the number of the
            # focused desktop switches to the last one.
            #
            # If you do not like this, just replace the whole if/fi part
            # below with $action (and do not quote it).
            if [ "$(_query_desktops --names)" -eq "$target_desktop" ]; then
                bspc desktop -f last
            else
                $action
            fi
        fi
    }

    # Reorder desktops on the target monitor (the target is the first
    # argument passed to this function).  The default is the focused
    # one.
    _desk_order() {
        while read -r line; do
            printf "%s\\n" "$line"
        done < <(bspc query -D -m "${1:-focused}" --names) | sort -g | paste -d ' ' -s
    }

    # Determines whether the behaviour of this function concerns nodes
    # or desktops.  The "monitor" is just a filter for nodes/desktops
    # (hence the `shift').  It concerns multihead setups.
    case "$1" in
        node|desktop)
            _dynamic_desktops 'focused.focused' bspc "$@"
            # Do not quote the following `$(…)` we want term splitting
            # here.  The next comment silences the `shellcheck' utility.
            #
            # shellcheck disable=SC2046
            bspc monitor -o $(eval _desk_order)
            ;;
        monitor)
            shift
            if [ -n "$dedicated_desktops" ]; then
                _dynamic_desktops "$dedicated_monitor" bspc "$@"
                # Do not quote the following `$(…)` we want term splitting
                # here.  The next comment silences the `shellcheck' utility.
                #
                # shellcheck disable=SC2046
                bspc monitor "$dedicated_monitor" -o $(eval _desk_order "$dedicated_monitor")
            else
                _dynamic_desktops next bspc "$@"
                # Do not quote the following `$(…)` we want term splitting
                # here.  The next comment silences the `shellcheck' utility.
                #
                # shellcheck disable=SC2046
                bspc monitor next -o $(eval _desk_order next)
            fi
            ;;
    esac
}

# Invoke the above command, passing to it arguments that change its
# behaviour (desktop or node).
#
# Mnemonics for shorter options:
# n* == node
# d* == desktop
case "$option" in
    --na|--send-all-to-desktop)
        _desk_or_node node 'any.local' -d "${target_desktop}"
        ;;
    --ns|--send-focused-to-desktop)
        if [ -n "$dedicated_desktops" ]; then
            _desk_or_node monitor node focused -d "${target_desktop}"
        else
            _desk_or_node node focused -d "${target_desktop}"
        fi
        ;;
    --nsf|--send-focused-to-desktop-and-follow)
        if [ -n "$dedicated_desktops" ]; then
            _desk_or_node monitor node focused -d "${target_desktop}" --follow
        else
            _desk_or_node node focused -d "${target_desktop}" --follow
        fi
        ;;
    --nm|--send-focused-to-next-monitor)
        _desk_or_node monitor node focused -d "${target_desktop}"
        ;;
    --nmf|--send-focused-to-next-monitor-and-follow)
        _desk_or_node monitor node focused -d "${target_desktop}" --follow
        ;;
    --da|--activate-desktop-and-place-receptacle)
        _desk_or_node monitor node @"$target_desktop":/ -i && bspc desktop -a "${target_desktop}"
        ;;
    --df|--focus-desktop)
        if [ -n "$dedicated_desktops" ]; then
            _desk_or_node monitor desktop -f "${target_desktop}"
        else
            _desk_or_node desktop -f "${target_desktop}"
        fi
        ;;
    *)
        echo "< $option > is not a valid option."
        exit 1
        ;;
esac

# Remove empty desktops.  This works for multiple monitors, as well.
# This will NOT REMOVE empty desktops that contain only receptacles
# (applies to the --activate-desktop option above).
for i in $(_query_desktops '.!focused.!occupied' --names); do
    bspc desktop "$i" -r
done
