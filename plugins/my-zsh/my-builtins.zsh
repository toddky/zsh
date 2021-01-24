
# These alias overwrite the default builtins
alias df='df -h'
alias du='du -ch'
alias echo='echo -e'

case "$OSTYPE" in
	darwin*)
		alias hostname='hostname -f'
		alias ls='LC_ALL=C ls -F -h -G'
		;;
	*)
		alias find='find -O3'
		alias hostname='hostname --long'
		alias ls='LC_ALL=C ls -F -h --color=auto --group-directories-first'
		;;
esac

alias less='less -r'
alias mkdir='mkdir -pv'
alias pwd='pwd -P'
alias which='whence -c -a'

