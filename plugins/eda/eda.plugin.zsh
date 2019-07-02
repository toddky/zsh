
local here=${0:h}

# ==============================================================================
# CTAGS
# ==============================================================================
function ctags_sv() {
	ctags $(git ls-files '*.v' '*.sv' '*.svh')
}


# ==============================================================================
# QUESTA
# ==============================================================================

# --- Modules ---
alias questaloadold='mload mentor/questasim/10.7_1'
alias questaload='mload mentor/questasim/2019.1_1'

# --- Aliases ---
alias ucdb_report_parse="awk '/^\s*CLASS/{class=\$2} \
/^\s*TYPE/{type=\$2} \
/^\s*Coverpoint/{coverpoint=\$2} \
/^\s*bin/{print class,type,coverpoint,\$2,\$3,\$4,\$5,\$6}'"

# --- Functions ---

# Dump and parse UCDB file into one-liners
function ucdb_dump() {
	which vcover || return 1
	vcover report -details $@ | ucdb_report_parse
}

# UCDB rank
function ucdb_rank() {
	which vcover || return 1
	vcover ranktest $@
}


# UCDB file summary
function ucdb_summary() {
	which vcover || return 1
	vcover report -totals $@
}

# View UCDB in GUI
function ucdb_view() {
	which vsim || return 1
	bs8 -app FG -Is -XF vsim -gui -viewcov $@
}

# Dump pdb into log file
function pdb_report() {
	which vsim || return 1
	local pdb=$1
	vsim -64 -c -do "profile open $pdb; profile report -file $pdb.log; quit -f"
}

# Grade a .ucdb file with a .do file
function my_fcovreport() {
	which vsim > /dev/null || return 1
	vcover report ${1?ucdb not specified} -detail -cvg -hidecvginsts -flat | awk '
		1
		/CVG/ {total++}
		($2==0) {missed++}
		END {
			hit = total - missed
			print "\n<<< Results >>>"
			print "Hit/Total = ", hit"/"total, "("100*hit/total"%)"
		}
	'
}

# Grade a .ucdb file with a .do file
function my_fcovgrade() {
	which vsim > /dev/null || return 1
	local dofile=$1 ucdb=$2 graded
	graded=$(dirname $ucdb)/$(basename $ucdb .ucdb).graded.ucdb
	[[ -f $graded ]] || vsim -c -do "coverage open $ucdb; source $dofile; coverage save $graded; quit -f"
	my_fcovreport $graded
}


# --- compdef ---
# Completion for *.ucdb files
function _ucdb_file() {
	_arguments "*:files:(($(ls *.ucdb)))"
}
compdef _ucdb_file ucdb_dump ucdb_rank ucdb_summary ucdb_view

# Completion for *.pdb files
function _pdb_file() {
	_arguments "*:files:(($(ls *.pdb)))"
}
compdef _pdb_file pdb_report


# ==============================================================================
# SYNOPSYS
# ==============================================================================

# --- Modules ---
#alias verdiload='mload novas/verdi3/2015.09'
alias verdiload='mload synopsys/verdi3/2017.12'

# --- Run ---
function bs_verdi() {
	which verdi || return 1
	bs32 -IS -XF verdi -ssv -ssy -f hw/config/top.vc -2001 -ssf E2W.fsdb -top top -syntaxerrormax 100000
}

# --- compdef ---
# Completion for *.fsdb files
function _fsdb_file() {
	_arguments "*:files:(($(ls *.fsdb)))"
}
compdef _fsdb_file bs_verdi


# ==============================================================================
# VELOCE
# ==============================================================================

# --- Modules ---
alias velload3018='mload mentor/veloce/3.0.1.8'
alias velload31611='mload mentor/veloce/3.16.1.1'
alias velload31612='mload mentor/veloce/3.16.1.2'
alias velload31614='mload mentor/veloce/3.16.1.4'
alias velload31615='mload mentor/veloce/3.16.1.5_patched'
alias velload31616='mload mentor/veloce/3.16.1.6'
alias velload31617='mload mentor/veloce/3.16.1.7'
alias velload31618='mload mentor/veloce/3.16.1.8'
alias velload1800='mload mentor/veloce/18.0.0'
alias velload='velload1800'

alias tbxload='mload mentor/tbx/2.4.4.9'
alias visload='mload mentor/questavdbg/10.6a'

alias stratoload1800='mload mentor/strato/18.0.0'
alias stratoload='stratoload1800'

# --- Information ---
alias veluse='velec -usagestat'
alias velavail='velec -availableres'
alias veldesign='velec -getdesigninfo $(readlink -f .)'
function velinfo() {
	awk 'BEGIN {estimated_freq = 0}
	/NUMBER OF CRYSTALS IN DESIGN/ {crystals = $NF}
	/AVAILABLE NUMBER OF CRYSTALS/ {max_crystals = $NF}
	/NUMBER OF ARRAY BOARDS/ {boards = $NF}
	!estimated_freq && /Frequency.*kHz/ {estimated_freq = $(NF-1)}
	/Frequency.*kHz/ {compile_freq = $(NF-1)}
	END {
		print "Crystals: "crystals"/"max_crystals
		print "Boards: "boards
		print "Estimated Frequency: "estimated_freq" kHz"
		print "Compile Frequency: "compile_freq" kHz"
		print "Degradation: "100*(estimated_freq-compile_freq)/estimated_freq"%"
	}' veloce.log/compile_velgs_0.log veloce.med/velsyn.out/velsyn.report
}

# --- Project ---
alias vellock='velcomp -lock_project'
alias velunlock='velcomp -unlock_project'
alias velcui='CUi_analyzer veloce.log -extract'
alias veltask='velcomp -task'
alias veldesign.bin='velunlock && veltask visualizer && vellock'

function vel_export_debug() {
	mkdir debug
	tmp=$(mktemp -d)
	output=$tmp/debug_info.tar.gz
	$VMW_HOME/tbx/bin/export_debug_info.csh -dir_path $PWD -o $output
	mv $output debug
}

function velcopy_logs() {
	mkdir -p veloce.log veloce.med/velsyn.out
	cp $1/compile.log .
	cp $1/veloce.config .
	cp $1/veloce.log/compile_velgs_0.log veloce.log/compile_velgs_0.log
	cp $1/veloce.med/velsyn.out/velsyn.report veloce.med/velsyn.out/velsyn.report
}

function vel2fsdb() {
	velload31618
	export LD_LIBRARY_PATH=/arm/tools/mentor/veloce/3.16.1.3/Veloce_v3.16.1.3/lib/amd64.linux.waveserver/:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=/arm/tools/mentor/veloce/3.16.1.3/Veloce_v3.16.1.0/debussy/share/FsdbWriter/LINUX64:$LD_LIBRARY_PATH
	echo '****************************' > sigs
	bs32 -o wave.%J.log ecf2wave -tracedir veloce.wave/waves.stw -siglist sigs -fsdb -distribute -merge_fsdbs
}

function visvel() {
	velload
	visload
	vis -veloce
}

alias velwave='velview -tracedir veloce.wave/waves.stw'
alias vis_open='vis -tracedir veloce.wave/waves.stw -designfile hw/veloce.med/visualizer.out/design.bin -fullt1t2'
alias vis_nortl='viswave tracedir veloce.wave/waves.stw'


# ==============================================================================
# ZEBU
# ==============================================================================

# --- Modules ---
alias zebuload='mload synopsys/zebu/2015.09-7_engfix_EF1'

# --- zSpy Aliases ---
alias zjobs='zSpy -batch -systemDir /arm/local/synopsys/zebu/zebu_system_dir_ZS3'
alias zfree='zSpy -free -systemDir /arm/local/synopsys/zebu/zebu_system_dir_ZS3'

# TODO: Figure out how to get this to work
#function zebu_pwd() {
	#local temp=${PWD##*/zebu*
#}

# TODO: Use zebu_pwd
function zebu_size() {
	ls -ldh build/zcui.work/backend_default/U?/M?
}

# TODO: Use zebu_pwd
function zebu_sum_cut() {
	grep 'SUM CUT' build/zcui.work/backend_default/Work.Part_*/zCoreBuild.log
}

