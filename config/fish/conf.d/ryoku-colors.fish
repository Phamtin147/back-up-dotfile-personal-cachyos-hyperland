# Ryoku palette for fish and fzf. Rendered by the theme daemon; do not edit.
#
# Dropped straight into conf.d, which fish sources on its own, so nothing in the
# shipped config has to include it. Your ~/.config/fish/user.fish loads last and
# still wins.

# Syntax highlighting.
set -g fish_color_normal 1e1c0e
set -g fish_color_command 924900
set -g fish_color_keyword 665e11
set -g fish_color_quote 884f20
set -g fish_color_redirection 4b472b
set -g fish_color_end 665e11
set -g fish_color_error b81919
set -g fish_color_param 1e1c0e
set -g fish_color_comment 4b472b
set -g fish_color_selection --background=ffdcc5
set -g fish_color_operator 665e11
set -g fish_color_escape 884f20
set -g fish_color_autosuggestion 4b472b
set -g fish_color_cancel b81919
set -g fish_color_search_match --background=ffdcc5
set -g fish_color_valid_path --underline

# Completion pager.
set -g fish_pager_color_progress 4b472b
set -g fish_pager_color_prefix 924900
set -g fish_pager_color_completion 1e1c0e
set -g fish_pager_color_description 4b472b
set -g fish_pager_color_selected_background --background=ffdcc5

# fzf takes the same palette, so Ctrl-R and Ctrl-T match the terminal they open
# in. Appended to whatever options are already set rather than replacing them.
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
--color=fg:#1e1c0e,bg:-1,hl:#924900 \
--color=fg+:#1e1c0e,bg+:#ffdcc5,hl+:#924900 \
--color=info:#884f20,prompt:#924900,pointer:#665e11 \
--color=marker:#665e11,spinner:#884f20,header:#4b472b \
--color=border:#cec7a3"
