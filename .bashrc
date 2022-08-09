# Prompt settings
[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
user="ruoyu"  # "\u"
host="Ruoyus-MacBook-Pro"  # "\h"
PS1="[$user@$host \W]\\$ "
unset user
unset host

# History control
HISTCONTROL=ignoreboth


