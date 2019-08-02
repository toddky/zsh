
# --- Source Files ---
local here=${0:h}
source $here/zsh-setup.zsh
for sourcefile in $here/modules/*.zsh; do
	source $sourcefile
done

# --- Site ---
alias sitename="hostname -f | sed 's/.*\.\([^.]\+\)\.arm\.com/\1/'"
alias nahpc='sitename | command grep -q nahpc'
alias euhpc='sitename | command grep -q euhpc'

alias getquota=/usr/local/bin/getquota
alias projinfo='projinfo 2>/dev/null'
function armdisk() {
	mount \
		| perl -pe 's/^(\S+arm.com):(\S+).*/\\\\\1\2/' \
		| sed -e 's/armhome/home/' \
		-e 's:/:\\:g' \
		-e 's:\\ifs::g'
}

# --- `cd` Aliases ---
alias cdscratch='cd ${PWD/\/projects/\/arm\/projectscratch}'
alias cdprojects='cd ${PWD/\/arm\/projectscratch/\/projects}'

# --- Environment Variables ---
#euhpc && [[ -z $LSB_BATCH_JID ]] && export LSB_DEFAULTPROJECT=PJ01384
#nahpc && [[ -z $LSB_BATCH_JID ]] && export LSB_DEFAULTPROJECT=PJ01384DEFAULT
export LSB_DEFAULTPROJECT=PJ02911HIGH
#nahpc && module load mosh/mosh/1.2.4

# --- Porter ---
#export PROJ_HOME=/projects/ssg/pj01384_porter/todyam01/porter
#export WORK_DIR=/arm/projectscratch/ssg/pj01384_porter/todyam01/porter
#source $PROJ_HOME/logical/shared/tools/bin/porter_rtl_setup_bash

# --- Mail ---
alias mailv='vi /var/spool/mail/$(whoami)'
function mailme { eval mail -s "'$@'" $(whoami)@arm.com; }
function execmail { mailme "$@" < <($@ 2>&1); }

# --- Service Now ---
function snow {
	mail -s "\"$@\"" "arm+ENG_inc@service-now.com"
}

#alias pastebin='awk '"'"'BEGIN{print "paste_text=$("} {print} END{print ")"}'"'"' | curl -X POST --netrc-file ~/.netrc -s --data-binary @- http://p.arm.com | grep -o "http[^\"]*" | xclip && xclip -o'

function pastebin() {
	mload haxx/curl/7.48.0
	local input=$(eval "$@")
	echo "$input"
	echo "$input" | curl -s -su todyam01 --data-binary @- http://p.arm.com | grep -o "http[^\"]*"
	#echo 'paste_text$('$input')' | curl -X POST -s --data-binary @- http://p.arm.com
	#curl -X POST --netrc-file ~/.netrc -s --data-binary @- http://p.arm.com

	#paste_text=$()

	#curl -X POST --netrc-file ~/.netrc -s --data-binary @- http://p.arm.com | grep -o "http[^\"]*" | xclip && xclip -o'
	#'awk '"'"'BEGIN{print "paste_text=$("} {print} END{print ")"}'"'"' | curl -X POST --netrc-file ~/.netrc -s --data-binary @- http://p.arm.com | grep -o "http[^\"]*" | xclip && xclip -o'
}

alias ldaparm='ldapsearch -LLL -h universe.arm.com -x -W -D uid=$USER,ou=people,dc=arm,dc=com -b ou=people,dc=arm,dc=com'
alias ldaparm2="ldapsearch -x -h universe.arm.com -b ou=people,dc=arm,dc=com uid='*'"

