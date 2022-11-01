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

# Plugins{{{
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

autoload -U compinit && compinit

# Aliases {{{
alias home='git --git-dir=$HOME/.home.git --work-tree=$HOME'
alias .nvim='GIT_DIR=$HOME/.home.git GIT_WORK_TREE=$HOME nvim'
alias h='home'
alias cdgr='cd-gitroot'
alias vim='nvim'
alias source-zshrc='source $ZDOTDIR/.zshrc'
alias edit-zshrc='$EDITOR $ZDOTDIR/.zshrc && source-zshrc'
alias jwtdec="jq -R 'gsub(\"-\";\"+\") | gsub(\"_\";\"/\") | split(\".\") | .[1] | @base64d | fromjson'"
alias ls='ls --color'
alias ..='cd ..'
alias ...='cd ../..'
alias startx='startx $XINITRC'
#}}}


[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"
[[ -f "$ZDOTDIR/.private.zsh" ]] && source "$ZDOTDIR/.private.zsh"
[[ "$OSTYPE" == "darwin"* ]] && source "$ZDOTDIR/.macos"
[[ -f "/opt/asdf-vm/asdf.sh" ]] && source /opt/asdf-vm/asdf.sh

# vim: set foldmethod=marker:
