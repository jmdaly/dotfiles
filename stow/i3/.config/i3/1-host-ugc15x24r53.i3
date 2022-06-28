# Name the workspaces
set $ws1  "1: Ford"
set $ws2  "2: Main"
set $ws3  "3: Coms"
set $ws4  "4"
set $ws5  "5"
set $ws6  "6"
set $ws7  "7"
set $ws8  "8"
set $ws9  "9: VPN"
set $ws10 "10"
# TODO how to rename without restarting https://faq.i3wm.org/question/1774/rename-workspace-with-i3-input-using-numbers-and-text.1.html

# Assign windows to a Workspace
assign [class="Stoken-gui"] $ws9
assign [class="Webex"] $ws3
assign [class="ZSTray"] $ws9

# Put Workspaces on specific monitors
# DP-0 = Older Dell
# DP-6 = Middle Dell
# DP-4 = Portrait Dell
# Position these with arandr, save the file, then paste the contents here:
exec --no-startup-id ~/.screenlayout/host.sh
workspace $ws1 output DP-0
workspace $ws2 output DP-6
workspace $ws3 output DP-4

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

