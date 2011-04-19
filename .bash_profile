umask 002
PS1='[\h]$ '
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi
alias ls='ls --color=auto'
case "$-" in *i*) byobu-launcher && exit 0; esac;
