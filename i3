# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

# gruvbox dark
set $background  #282828
set $foreground  #ebdbb2
set $black       #282828
set $darkgrey    #928374
set $darkred     #cc241d
set $red         #fb4934
set $darkgreen   #98971a
set $green       #b8bb26
set $darkyellow  #d79921
set $yellow      #fabd2f
set $darkblue    #458588
set $blue        #83a598
set $darkmagenta #b16286
set $magenta     #d3869b
set $darkcyan    #689d6a
set $cyan        #8ec07c
set $lightgrey   #a89984
set $white       #ebdbb2

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:System San Francisco Display 10

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
# bindsym $mod+Return exec i3-sensible-terminal
set $terminal st
bindsym $mod+Return exec $terminal

# kill focused window
bindsym $mod+Shift+q kill

# start rofi (a program launcher)
bindsym $mod+d exec --no-startup-id rofi -show run

# change focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+semicolon focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# shortcut to move a workspace to a monitor to the right
bindsym $mod+m move workspace to output right

set $workspace1 "1: Editor "
set $workspace2 "2: Chrome "
set $workspace3 "3: Project "

# switch to workspace
bindsym $mod+1 workspace $workspace1
bindsym $mod+2 workspace $workspace2
bindsym $mod+3 workspace $workspace3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $workspace1
bindsym $mod+Shift+2 move container to workspace $workspace2
bindsym $mod+Shift+3 move container to workspace $workspace3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# Program workspaces
assign [class="google-chrome"] $workspace2

# Ensure certain programs always start floating:
for_window [class="zoom"] floating enable

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym semicolon resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Widow Colours
#                       border  background text    indicator
client.focused          $foreground $foreground $background $foreground
client.focused_inactive $darkgrey $darkgrey $foreground $darkgrey
client.unfocused        $darkgrey $darkgrey $foreground $darkgrey
client.urgent           $red $red $background $red

# Disable window titlebars. Necessary for i3-gaps:
for_window [class="^.*"] border pixel 0
# Set gaps:
set $default_gaps_inner 10
set $default_gaps_outer 5
gaps inner $default_gaps_inner
gaps outer $default_gaps_outer

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
        status_command i3blocks
        position top
        colors {
          background $background
          statusline $foreground
          separator $darkgrey

          focused_workspace  $background $background $foreground
          active_workspace   $background $background $foreground
          inactive_workspace $background $background $darkgrey
          urgent_workspace   $background $background $red
         }
}

bindsym $mod+shift+x exec i3lock

# Pulse Audio controls. The pkill signals here are to tell i3blocks to update
# the volume blocklet.
# increase sound volume
bindsym XF86AudioRaiseVolume exec --no-startup-id "pactl set-sink-volume 0 +5%; pkill -RTMIN+10 i3blocks" 
# Note, I had to add the -- to the command below to get this to
# work in Ubuntu 14.04. From what I read online, this may have to be
# removed for newer versions of Ubuntu.
# decrease sound volume
bindsym XF86AudioLowerVolume exec --no-startup-id "pactl set-sink-volume 0 -- -5%; pkill -RTMIN+10 i3blocks" 
# mute sound
bindsym XF86AudioMute exec --no-startup-id "pactl set-sink-mute 0 toggle; pkill -RTMIN+10 i3blocks" 

# Sreen brightness controls
bindsym XF86MonBrightnessUp exec xbacklight -inc 20 # increase screen brightness
bindsym XF86MonBrightnessDown exec xbacklight -dec 20 # decrease screen brightness

# Startup applications:
exec google-chrome
exec --no-startup-id nm-applet
# Start up terminals on multiple workspaces. Since we
# launch the same application on multiple workspaces like
# this, we need to use i3-msg and explicitly switch
# workspaces
exec --no-startup-id i3-msg 'workspace $workspace1; exec $terminal' 
# On faster computers this sleep seems necessary to get the terminal
# to load on a workspace that's different from the one in the previous
# command:
exec --no-startup-id sleep 0.1 && i3-msg 'workspace $workspace3; exec $terminal' 

# Set wallpaper:
exec_always --no-startup-id feh --bg-fill $HOME/.config/wallpapers/wall.png
