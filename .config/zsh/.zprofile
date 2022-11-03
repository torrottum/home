export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"

if [[ $OSTYPE == "linux-gnu" ]]; then
    export SSH_AUTH_SOCK="/run/user/$(id -u)/keyring/ssh"
fi
