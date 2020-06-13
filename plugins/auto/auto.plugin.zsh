
local here=${0:h}

# Add current location to to fpath
if [[ ! " ${fpath[@]} " =~ " ${here} " ]]; then
	fpath=($here $fpath)
fi

# Autoload everything
local b f
for f in $here/*; do
	b="$(basename "$f")"
	[[ "$b" =~ '^_' ]] && continue
	[[ "$b" =~ '\.zsh$' ]] && continue
	autoload $b
done

