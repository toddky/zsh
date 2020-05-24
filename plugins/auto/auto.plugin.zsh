
local here=${0:h}

if [[ ! " ${fpath[@]} " =~ " ${here} " ]]; then
	fpath=($here $fpath)
fi

# ==============================================================================
# FUNCTIONS
# ==============================================================================
autoload timezone


# ==============================================================================
# MODULES
# ==============================================================================
autoload ag
autoload burst
autoload fish
autoload htop
autoload meld
autoload node
autoload pdf
autoload tig
autoload tkdiff
autoload zSpy
# Questa
autoload vcover
autoload vsim
# Verdi
autoload verdi
autoload vcd2fsdb
# Veloce
autoload velcomp
autoload velec
autoload velrun

