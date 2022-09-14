#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

style="$($HOME/.config/rofi/applets/menu/style.sh)"

dir="$HOME/.config/rofi/applets/menu/configs/$style"
rofi_command="rofi -theme $dir/screenshot.rasi"

# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/applets/styles/message.rasi" -e "$@"
}

if [[ ! -f /usr/bin/scrot ]]; then
  msg "Please install 'scrot' first."
  exit 1
fi

# Options
screen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$area\n$window"

chosen="$(echo -e "$options" | $rofi_command -p 'App : scrot' -dmenu -selected-row 1)"
case $chosen in
    $screen)
      sname='Screenshot_%Y-%m-%d-%S_$wx$h.png'
      flag=""
        ;;
    $area)
      sname='Screenshot_%Y-%m-%d-%S_$wx$h.png'
      flag="-s"
        ;;
    $window)
      sname='Screenshot_%Y-%m-%d-%S_$wx$h.png'
      flag="-s"
        ;;
esac
sleep 0.2; scrot ${flag} ${sname} -e 'mv $f /tmp ; ln -s /tmp/$f /tmp/latest.png'

if [[ -e /tmp/latest ]]; then
  viewnior /tmp/latest.png

  # Makes this easier for WebEx
  ln -s $(readlink /tmp/latest.png) ${HOME}/Documents/

  # Put the image in the clip board (again, easier to deal with)
  xclip -selection clipboard -t image/png -i /tmp/latest.png
fi
