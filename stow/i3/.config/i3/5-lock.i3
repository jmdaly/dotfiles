# Set the screens to turn off after 600 seconds of inactivity:
exec "xset dpms 600"

# The combination of xss-lock, nm-applet and pactl is a popular choice, so
# they are included here as an example. Modify as you see fit.

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

# Lock screen
bindsym Ctrl+mod1+L exec ${HOME}/bin/do_lock.sh
