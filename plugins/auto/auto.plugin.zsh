
local here=${0:h}

if [[ ! " ${fpath[@]} " =~ " ${here} " ]]; then
	fpath=($here $fpath)
fi

autoload ag
autoload burst
autoload fish
autoload htop
autoload meld
autoload node
autoload pdf
autoload tig
autoload tkdiff
autoload vcover
autoload velcomp
autoload velec
autoload velrun
autoload vsim
autoload zSpy

autoload verdi
autoload vcd2fsdb

