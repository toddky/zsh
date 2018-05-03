
# --- Modules ---
alias questaload='mload mentor/questasim/10.7_1'


# --- Aliases ---
alias ucdb_report_parse="awk '/^\s*CLASS/{class=\$2} \
/^\s*TYPE/{type=\$2} \
/^\s*Coverpoint/{coverpoint=\$2} \
/^\s*bin/{print class,type,coverpoint,\$2,\$3,\$4,\$5}'"


# --- Functions ---

# Dump and parse UCDB file into one-liners
function ucdb_dump() {
	which vcover || return 1
	vcover report -details $@ | ucdb_report_parse
}

# View UCDB in GUI
function ucdb_view() {
	which vsim || return 1
	bs8 -app FG -Is -XF vsim -gui -viewcov $@
}


# --- compdef ---

# Completion for *.ucdb files
function _ucdb_file() {
	_arguments "*:files:(($(ls *.ucdb)))"
}
compdef _ucdb_file ucdb_dump ucdb_view

