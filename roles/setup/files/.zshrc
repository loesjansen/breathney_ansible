# ansible managed
autoload -U colors && colors

autoload -Uz compinit && compinit -C
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
compctl -g '~/.teamocil/*(:t:r)' teamocil

autoload up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload down-line-or-beginning-search
zle -N down-line-or-beginning-search

unsetopt beep

setopt hist_ignore_dups
setopt hist_ignore_space

bindkey -v # vi keybindings instead of emacs keybindings

zstyle :compinstall filename '/home/bbbart/.zshrc'

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## coloured man pages in less
man() {
	env LESS_TERMCAP_mb=$'\E[01;31m' \
	LESS_TERMCAP_md=$'\E[01;38;5;74m' \
	LESS_TERMCAP_me=$'\E[0m' \
	LESS_TERMCAP_se=$'\E[0m' \
	LESS_TERMCAP_so=$'\E[38;5;246m' \
	LESS_TERMCAP_ue=$'\E[0m' \
	LESS_TERMCAP_us=$'\E[04;38;5;146m' \
	man "$@"
}

## fix some keys, like home and end
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
#[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
#[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       history-beginning-search-backward
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-beginning-search
#[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
#[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     history-beginning-search-forward
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-beginning-search
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

bindkey "" end-of-line
bindkey "" beginning-of-line

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
		printf '%s' "${terminfo[smkx]}"
	}
	function zle-line-finish () {
		printf '%s' "${terminfo[rmkx]}"
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

## ENVIRONMENT VARIABLES
if [ ${USER} = 'root' ]
then
    PROMPT="[%*] %{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%~ %{$reset_color%}%# "
else
    PROMPT="[%*] %{$fg[green]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%~ %{$reset_color%}%# "
fi
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
PATH=$PATH:$HOME/bin

export TEXMFHOME=$HOME/.texmf
export EDITOR=vim

alias lh='ls -lh --color=auto'
alias grep='grep --color=auto'

export KEYTIMEOUT=1

if [ x${TMUX} = "x" ]
then
    export TERM=xterm-color
else
    export TERM=screen-256color
fi

if [ -f .zshrc.local ]
then
    source .zshrc.local
fi
