# vim: set foldmethod=marker:
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zinit install and loading {{{
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    echo "Installing zdharma-continuum/zinit…"
    git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" || \
        echo 'Failed to clone zinit.'
fi
source "$ZINIT_HOME/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}}

# Plugins {{{
zinit ice depth"1"
zinit light romkatv/powerlevel10k
zinit ice depth"1"
zinit light zsh-users/zsh-completions
zinit ice depth"1"
zinit light agkozak/zsh-z
zinit ice depth"1"
zinit light mollifier/cd-gitroot
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::completion.zsh
# }}}

# Autocompletion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
if hash aws_completer 2> /dev/null; then
    complete -C "$(which aws_completer)" aws
fi

# Aliases {{{
alias home='git --git-dir=$HOME/.home.git --work-tree=$HOME'
alias .nvim='GIT_DIR=$HOME/.home.git GIT_WORK_TREE=$HOME nvim'
alias fnvim='nvim --noplugin' # For the times I fuck up
alias h='home'
alias cdgr='cd-gitroot'
alias vim='nvim'
alias source-zshrc='source $ZDOTDIR/.zshrc'
alias edit-zshrc='cd $HOME/.config/zsh && .nvim $ZDOTDIR/.zshrc && source-zshrc'
alias edit-nvim='cd $HOME/.config/nvim &&cd $HOME/.config/zsh &&  .nvim init.lua'
alias jwtdec="jq -R 'gsub(\"-\";\"+\") | gsub(\"_\";\"/\") | split(\".\") | .[1] | @base64d | fromjson'"
alias ls='ls --color'
alias ..='cd ..'
alias ...='cd ../..'
alias startx='startx $XINITRC'
alias edit-xmonad='cd $HOME/.config/xmonad && .nvim xmonad.hs'
#}}}

# Conditional sourcing
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"
[[ -f "$ZDOTDIR/.private.zsh" ]] && source "$ZDOTDIR/.private.zsh"
[[ "$OSTYPE" == "darwin"* ]] && source "$ZDOTDIR/.macos"
[[ -f "/opt/asdf-vm/asdf.sh" ]] && source /opt/asdf-vm/asdf.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
[[ -f "/usr/share/nvm/init-nvm.sh" ]] && source "/usr/share/nvm/init-nvm.sh"

# Set alacritty title {{{
if [[ "${TERM:-}" == "alacritty" ]]; then
    precmd() {
        print -Pn "\e]0;alacritty: %~\a"
    }
    preexec() {
        echo -en "\e]0;alacritty: ${1}\a"
    }
fi
##}}}

# pnpm
export PNPM_HOME="/home/tor/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
