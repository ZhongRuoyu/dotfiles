# PS1 settings
[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
HOST_="Ruoyus-MacBook-Pro"
PS1="[\u@$HOST_ \W]\\$ "
unset HOST_

# History control
export HISTCONTROL=ignorespace


