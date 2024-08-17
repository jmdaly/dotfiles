if type -q tide
    tide configure --auto \
        --style=Classic \
        --prompt_colors='16 colors' \
        --show_time='24-hour format' \
        --classic_prompt_separators=Angled \
        --powerline_prompt_heads=Sharp \
        --powerline_prompt_tails=Flat \
        --powerline_prompt_style='Two lines, character and frame' \
        --prompt_connection=Dotted \
        --powerline_right_prompt_frame=No \
        --prompt_spacing=Sparse \
        --icons='Many icons' \
        --transient=No
end
