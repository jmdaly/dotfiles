# Print screen.  With Apply keyboard, ensure apple:alupckeys is set.  Also
# ensure scrot is installed (or change this to gnome-screenshot or something)
# take full sreenshot
bindsym Print exec scrot 'screenshot_%F__%H-%M-%S.png' -e 'mv $f /tmp/'
# take screenshot with selection
bindsym --release shift+Print exec scrot -s 'screenshot_%F__%H-%M-%S.png' -e 'mv $f /tmp/'
# take screenshot of focused window
bindsym ctrl+Print exec scrot -u 'screenshot_%F__%H-%M-%S.png' -e 'mv $f /tmp/'
