
# --- Modules ---
alias verdiload='mload novas/verdi3/2015.09'

# --- Run ---
alias bs_verdi="verdiload && bs32 -IS -XF verdi -ssv -ssy -f hw/config/top.vc -2001 -ssf E2W.fsdb -top top -syntaxerrormax 100000"

