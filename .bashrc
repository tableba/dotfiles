#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

#install dependencies for lvim & path for lvim
export PATH="$HOME/.cargo/bin":$PATH
export PATH="$HOME/.local/bin":$PATH


# dark theme
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=Adwaita
