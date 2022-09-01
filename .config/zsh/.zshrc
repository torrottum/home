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
alias home='git --git-dir=$HOME/.homerepo --work-tree=$HOME'
alias cdgr='cd-gitroot'
alias vim='nvim'
alias editzshrc='$EDITOR $ZDOTDIR/.zshrc && source $ZDOTDIR/.zshrc'
#}}}


[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"
[[ "$OSTYPE" == "darwin"* ]] && source "$ZDOTDIR/.macos"

# vim: set foldmethod=marker:
