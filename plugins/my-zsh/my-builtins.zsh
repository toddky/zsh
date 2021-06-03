
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

# grep -------------------------------------------------------------------------
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/grep.zsh
GREP_OPTIONS="--color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
alias fgrep="fgrep $GREP_OPTIONS"
unset GREP_OPTIONS

