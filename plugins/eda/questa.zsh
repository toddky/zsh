
# --- Modules ---
alias questaloadold='mload mentor/questasim/10.7_1'
alias questaload='mload mentor/questasim/2019.1_1'


# ==============================================================================
# ALIASES
# ==============================================================================
alias ucdb_report_parse="awk '/^\s*CLASS/{class=\$2} \
/^\s*TYPE/{type=\$2} \
/^\s*Coverpoint/{coverpoint=\$2} \
/^\s*bin/{print class,type,coverpoint,\$2,\$3,\$4,\$5}'"


# ==============================================================================
# FUNCTIONS
# ==============================================================================

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
function my_fcovgrade() {
	which vsim || return 1
	local dofile=$1 ucdb=$2 graded
	graded=$(dirname $ucdb)/$(basename $ucdb .ucdb).graded.ucdb
	vsim -c -do "coverage open $ucdb; source $dofile; coverage save $graded; quit -f"
}


# ==============================================================================
# COMPDEF
# ==============================================================================

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

