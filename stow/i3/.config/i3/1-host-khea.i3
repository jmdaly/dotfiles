# TODO how to rename without restarting https://faq.i3wm.org/question/1774/rename-workspace-with-i3-input-using-numbers-and-text.1.html

# Assign windows to a Workspace
assign [class="qBittorrent"] $ws10

# Put Workspaces on specific monitors
# DVI-D-2 = Wide Dell
# DVI-D-1 = Big Shimian
# HDMI-1 = ASUS
# Position these with arandr, save the file, then paste the contents here:
exec --no-startup-id xrandr --output VGA-0 --off --output DVI-D-0 --primary --mode 2560x1440 --pos 2560x0 --rotate normal --output DVI-D-1 --mode 2560x1080 --pos 0x160 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 5120x360 --rotate normal
workspace $ws1 output DVI-D-1
workspace $ws2 output DVI-D-2
workspace $ws3 output HDMI-1
