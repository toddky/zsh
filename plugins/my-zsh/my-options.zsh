
# `man zshoptions`

# ==============================================================================
# SPELL CHECK
# ==============================================================================
# https://hund0b1.gitlab.io/2018/08/04/spell-check-and-auto-correction-of-commands-in-zsh.html
setopt correct
export SPROMPT="Use $fg_bold[green]%r$reset_color instead of $fg_bold[red]%R$reset_color? "


# ==============================================================================
# MISCELLANEOUS
# ==============================================================================
# Disable annoying beeps
unsetopt BEEP
# Print red [stderr] for stderr
unsetopt MULTIOS
exec 9>&2 2> >(while read line; do echo "\e[31m[stderr]\e[0m $line"; done; )
exec 2>&- 2>&9


# ==============================================================================
# PERMISSIONS
# ==============================================================================
# rw-rw-r-- files
# rwxrwxr-x directories
umask 002
# rw-r--r-- files
# rwxr-xr-x directories
#umask 022


# ==============================================================================
# CHANGING DIRECTORY
# ==============================================================================
# `dir` -> `cd dir`
setopt AUTO_CD
# `cd dir` -> `push dir`
setopt AUTO_PUSHD
# `cd symlink/..` -> `cd /symlink/physical/path/..`
setopt CHASE_DOTS
# Do not search ~users
unsetopt CDABLE_VARS
# `cd symlink && pwd` ->  `echo /physical/path/to/symlink`
setopt CHASE_LINKS
# Do not push duplicate directories
setopt PUSHD_IGNORE_DUPS
# Silent `pushd` and `popd`
setopt PUSHD_SILENT
# `pushd` -> `pushd $HOME`
setopt PUSHD_TO_HOME


# ==============================================================================
# COMPLETION
# ==============================================================================
# Move cursor to end of word at full completion
setopt ALWAYS_TO_END
# List choice on ambiguous completion
setopt AUTO_LIST
# Cursor stays in place until completed on both ends
setopt COMPLETE_IN_WORD


# ==============================================================================
# EXPANSION/GLOBBING
# ==============================================================================
setopt EXTENDED_GLOB
# Case-insensitive matching
unsetopt CASE_GLOB
# Report errors if no matches
unsetopt CSH_NULL_GLOB
# Report errors if no matches
unsetopt NULL_GLOB


# ==============================================================================
# HISTORY
# ==============================================================================
# Example available here:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh

# History file configuration
# TODO: Move $HISTFILE
#HISTFILE="$HOME/config/zsh/history"
#[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/config/zsh/history"
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# Append parallel zsh sessions
setopt APPEND_HISTORY
# Add commands to HISTFILE in order of execution
setopt INC_APPEND_HISTORY
# Perform textual history expansion
setopt BANG_HIST
# Save timestamps and duration
setopt EXTENDED_HISTORY
# Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_EXPIRE_DUPS_FIRST
# Remove older duplicates when added
setopt HIST_IGNORE_ALL_DUPS
# Remove extra whitespace
setopt HIST_REDUCE_BLANKS
# Show expanded command before running it
setopt HIST_VERIFY
# Share command history data
setopt SHARE_HISTORY
# Ignore commands that start with space
unsetopt HIST_IGNORE_SPACE

