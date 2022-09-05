export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"
export ZDOTDIR="${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}"
if [ -f "$ZDOTDIR/.zshenv" ]; then
    source "$ZDOTDIR/.zshenv"
fi
