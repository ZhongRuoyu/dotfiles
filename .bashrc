# Prompt settings
[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "


# History control
HISTCONTROL=ignoreboth


# Local bash settings
if [ -e "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi


