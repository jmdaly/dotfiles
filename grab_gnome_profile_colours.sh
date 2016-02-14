#!/bin/zsh

# Solarized
#http://michaelheap.com/getting-solarized-working-on-ubuntu/
# Note, the dircolors are loaded here already with a git submodule

# Grab the value with: 
# gconftool-2 -g "/apps/gnome-terminal/profiles/Profile0/background_color"
# Set it with:
# gconftool-2 --set "/apps/gnome-terminal/profiles/Profile0/background_color" --type string "#FFFFFEB7B69C"

# GTK uses 16 bit colour channels. #rgb, #rrggbb, and #rrrrggggbbbb are accepted.

# Some notes on solarized
# Original text-colour: #65657B7B8383, changed to: #7c96a0
# Palette  #2: String colour in VI
# Palette #11: Prompt colour on shell

echo "# Exporting $(hostname) terminal profiles." > profiles.dot
echo " " > profiles.dot

declare -a string_keys;
declare -a bool_keys;
string_keys=(visible_name palette foreground_color background_color);
bool_keys=(use_theme_background use_theme_colors);
for prof in Default Profile{0,1,2,3,4,5,6,7,8,9,10,11}; do
	echo "# $prof" >> profiles.dot
	for k in $string_keys; do
		echo "gconftool-2 --set \"/apps/gnome-terminal/profiles/$prof/$k\" --type string \"$(gconftool-2 -g /apps/gnome-terminal/profiles/$prof/$k)\"" >> profiles.dot
	done;
	for k in $bool_keys; do
		val=$(gconftool-2 -g /apps/gnome-terminal/profiles/$prof/$k);
		if [[ "${val}" != "" ]]; then
			echo "gconftool-2 --set \"/apps/gnome-terminal/profiles/$prof/$k\" --type bool \"${val}\"" >> profiles.dot
		fi;
	done;
	echo " " >> profiles.dot
done;

# vim: ts=3 sw=3 sts=0 noet :
