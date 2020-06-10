
local here=${0:h}

# ==============================================================================
# AWK
# ==============================================================================

alias awkvars="cat $here/awk.variables.txt"
alias awk.ts="$here/bin/timestamp.awk"

function awkc() {
	local col=$1
	shift
	awk '{print $'$col'}' $@;
}
#for i in $(seq 1 11); do alias -g col$i="| awkc $i"; done

function awkr() {
	local row=$1
	shift
	awk '(NR=='$row'){print $0}' $@
}
#for i in $(seq 1 11); do alias -g row$i="| awkr $i"; done

function awk_match() {
	awk 'match($0,/'$1'/, groups) {print groups['${2:-'0'}']}'
}


# ==============================================================================
# GREP
# ==============================================================================

# oh-my-zsh already aliases grep
# grep: aliased to grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}

alias gu='grep $(whoami)'
alias psg='psaux | g -i -e VSZ -e'


# ==============================================================================
# PERL
# ==============================================================================

alias perlne='perl -ne'

function pregex() {
	local pattern="$@"
	perlne 'next unless @match=($_=~'"$pattern"'); print join(" ",@match)."\n"'
}


# ==============================================================================
# SED
# ==============================================================================
alias noansi='sed "s:\x1B\[[0-9;]*[a-zA-Z]::g"'


# ==============================================================================
# TR
# ==============================================================================
alias 'tr:'="tr ':' \$'\\n'"

