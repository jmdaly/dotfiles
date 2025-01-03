if status is-interactive
    # Set the tide prompt. I obtained these variables by running `tide
    # configure` and then copying the universal variables that get set in
    # `fish_variables` to this file.
    set -U _tide_left_items os\x1epwd\x1egit\x1enewline\x1echaracter
    set -U _tide_right_items status\x1ecmd_duration\x1econtext\x1ejobs\x1enode\x1epython\x1eruby\x1egcloud\x1etime
    set -U tide_aws_bg_color black
    set -U tide_aws_color yellow
    set -U tide_aws_icon \uf270
    set -U tide_character_color brgreen
    set -U tide_character_color_failure brred
    set -U tide_character_icon \u276f
    set -U tide_character_vi_icon_default \u276e
    set -U tide_character_vi_icon_replace \u25b6
    set -U tide_character_vi_icon_visual V
    set -U tide_cmd_duration_bg_color black
    set -U tide_cmd_duration_color brblack
    set -U tide_cmd_duration_decimals 0
    set -U tide_cmd_duration_icon \uf252
    set -U tide_cmd_duration_threshold 3000
    set -U tide_context_always_display false
    set -U tide_context_bg_color black
    set -U tide_context_color_default yellow
    set -U tide_context_color_root bryellow
    set -U tide_context_color_ssh yellow
    set -U tide_context_hostname_parts 1
    set -U tide_crystal_bg_color black
    set -U tide_crystal_color brwhite
    set -U tide_crystal_icon \ue62f
    set -U tide_direnv_bg_color black
    set -U tide_direnv_bg_color_denied black
    set -U tide_direnv_color bryellow
    set -U tide_direnv_color_denied brred
    set -U tide_direnv_icon \u25bc
    set -U tide_distrobox_bg_color black
    set -U tide_distrobox_color brmagenta
    set -U tide_distrobox_icon \U000f01a7
    set -U tide_docker_bg_color black
    set -U tide_docker_color blue
    set -U tide_docker_default_contexts default\x1ecolima
    set -U tide_docker_icon \uf308
    set -U tide_elixir_bg_color black
    set -U tide_elixir_color magenta
    set -U tide_elixir_icon \ue62d
    set -U tide_gcloud_bg_color black
    set -U tide_gcloud_color blue
    set -U tide_gcloud_icon \U000f02ad
    set -U tide_git_bg_color black
    set -U tide_git_bg_color_unstable black
    set -U tide_git_bg_color_urgent black
    set -U tide_git_color_branch brgreen
    set -U tide_git_color_conflicted brred
    set -U tide_git_color_dirty bryellow
    set -U tide_git_color_operation brred
    set -U tide_git_color_staged bryellow
    set -U tide_git_color_stash brgreen
    set -U tide_git_color_untracked brblue
    set -U tide_git_color_upstream brgreen
    set -U tide_git_icon \uf1d3
    set -U tide_git_truncation_length 24
    set -U tide_git_truncation_strategy \x1d
    set -U tide_go_bg_color black
    set -U tide_go_color brcyan
    set -U tide_go_icon \ue627
    set -U tide_java_bg_color black
    set -U tide_java_color yellow
    set -U tide_java_icon \ue256
    set -U tide_jobs_bg_color black
    set -U tide_jobs_color green
    set -U tide_jobs_icon \uf013
    set -U tide_jobs_number_threshold 1000
    set -U tide_kubectl_bg_color black
    set -U tide_kubectl_color blue
    set -U tide_kubectl_icon \U000f10fe
    set -U tide_left_prompt_frame_enabled true
    set -U tide_left_prompt_items os\x1epwd\x1egit\x1enewline\x1echaracter
    set -U tide_left_prompt_prefix 
    set -U tide_left_prompt_separator_diff_color \ue0b0
    set -U tide_left_prompt_separator_same_color \ue0b1
    set -U tide_left_prompt_suffix \ue0b0
    set -U tide_nix_shell_bg_color black
    set -U tide_nix_shell_color brblue
    set -U tide_nix_shell_icon \uf313
    set -U tide_node_bg_color black
    set -U tide_node_color green
    set -U tide_node_icon \ue24f
    set -U tide_os_bg_color black
    set -U tide_os_color brwhite
    set -U tide_php_bg_color black
    set -U tide_php_color blue
    set -U tide_php_icon \ue608
    set -U tide_private_mode_bg_color black
    set -U tide_private_mode_color brwhite
    set -U tide_private_mode_icon \U000f05f9
    set -U tide_prompt_add_newline_before true
    set -U tide_prompt_color_frame_and_connection brblack
    set -U tide_prompt_color_separator_same_color brblack
    set -U tide_prompt_icon_connection \u00b7
    set -U tide_prompt_min_cols 34
    set -U tide_prompt_pad_items true
    set -U tide_prompt_transient_enabled false
    set -U tide_pulumi_bg_color black
    set -U tide_pulumi_color yellow
    set -U tide_pulumi_icon \uf1b2
    set -U tide_pwd_bg_color black
    set -U tide_pwd_color_anchors brcyan
    set -U tide_pwd_color_dirs cyan
    set -U tide_pwd_color_truncated_dirs magenta
    set -U tide_pwd_icon \uf07c
    set -U tide_pwd_icon_home \uf015
    set -U tide_pwd_icon_unwritable \uf023
    set -U tide_pwd_markers \x2ebzr\x1e\x2ecitc\x1e\x2egit\x1e\x2ehg\x1e\x2enode\x2dversion\x1e\x2epython\x2dversion\x1e\x2eruby\x2dversion\x1e\x2eshorten_folder_marker\x1e\x2esvn\x1e\x2eterraform\x1eCargo\x2etoml\x1ecomposer\x2ejson\x1eCVS\x1ego\x2emod\x1epackage\x2ejson\x1ebuild\x2ezig
    set -U tide_python_bg_color black
    set -U tide_python_color cyan
    set -U tide_python_icon \U000f0320
    set -U tide_right_prompt_frame_enabled false
    set -U tide_right_prompt_items status\x1ecmd_duration\x1econtext\x1ejobs\x1edirenv\x1enode\x1epython\x1erustc\x1ejava\x1ephp\x1epulumi\x1eruby\x1ego\x1egcloud\x1ekubectl\x1edistrobox\x1etoolbox\x1eterraform\x1eaws\x1enix_shell\x1ecrystal\x1eelixir\x1ezig\x1etime
    set -U tide_right_prompt_prefix \ue0b2
    set -U tide_right_prompt_separator_diff_color \ue0b2
    set -U tide_right_prompt_separator_same_color \ue0b3
    set -U tide_right_prompt_suffix 
    set -U tide_ruby_bg_color black
    set -U tide_ruby_color red
    set -U tide_ruby_icon \ue23e
    set -U tide_rustc_bg_color black
    set -U tide_rustc_color red
    set -U tide_rustc_icon \ue7a8
    set -U tide_shlvl_bg_color black
    set -U tide_shlvl_color yellow
    set -U tide_shlvl_icon \uf120
    set -U tide_shlvl_threshold 1
    set -U tide_status_bg_color black
    set -U tide_status_bg_color_failure black
    set -U tide_status_color green
    set -U tide_status_color_failure red
    set -U tide_status_icon \u2714
    set -U tide_status_icon_failure \u2718
    set -U tide_terraform_bg_color black
    set -U tide_terraform_color magenta
    set -U tide_terraform_icon \U000f1062
    set -U tide_time_bg_color black
    set -U tide_time_color brblack
    set -U tide_time_format \x25T
    set -U tide_toolbox_bg_color black
    set -U tide_toolbox_color magenta
    set -U tide_toolbox_icon \ue24f
    set -U tide_vi_mode_bg_color_default black
    set -U tide_vi_mode_bg_color_insert black
    set -U tide_vi_mode_bg_color_replace black
    set -U tide_vi_mode_bg_color_visual black
    set -U tide_vi_mode_color_default white
    set -U tide_vi_mode_color_insert cyan
    set -U tide_vi_mode_color_replace green
    set -U tide_vi_mode_color_visual yellow
    set -U tide_vi_mode_icon_default D
    set -U tide_vi_mode_icon_insert I
    set -U tide_vi_mode_icon_replace R
    set -U tide_vi_mode_icon_visual V
    set -U tide_zig_bg_color black
    set -U tide_zig_color yellow
    set -U tide_zig_icon \ue6a9
end
