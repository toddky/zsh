
# https://gist.github.com/romkatv/605b8ae4499458565e13f715abbd2636

# Runs "$@" in a subshell with the caller's options, sets reply=(stdout stderr)
# and returns the status of the executed command. Both stdout and stderr are
# captured completely, including NUL bytes, incomplete UTF-8 characters and
# trailing LF, if any.
#
# Example:
#
#   % zsh-run-command ls -d ~ /garbage
#   % printf 'status: %s\nstdout: %s\nstderr: %s\n' $? "${(q+)reply[@]}"
#   status: 2
#   stdout: $'/home/romka\n'
#   stderr: $'ls: cannot access \'/garbage\': No such file or directory\n'
#
# Note that aliases in "$@" don't get expanded. If you need to run a command
# with alias expansion, use eval:
#
#   % zsh-run-command eval 'foo bar'
#
# Implementation notes:
#
# - Don't change shell options before running the command. The caller's
#   options may be important for it.
# - Be mindful of err_return and err_exit that may be set by the caller.
# - Don't change `reply` before running the command. It might be using it.
# - Don't assume that the output of the command is text. It can be binary data.
# - Remember that $(...) strips trailing LF.
# - Don't change any file descriptors except for 1 and 2 because the command
#   might be using them.
# - Make sure that commands such as `exit` and `return 12345` work.
# - Think what would happen if the command kills its parent process, or if zsh
#   cannot fork.
# - Use ugly names for parameters in scope of the command to avoid hiding
#   globals that it might use.
# - Quote everything to prevent alias expansion.
# - Prefix all builtins with 'builtin' to avoid invoking user-defined functions.
zsh-run-command() {
  'builtin' 'local' '__zrc'
  __zrc="$(
    __zrc="$( ("$@") || __zrc="$?"; 'builtin' 'printf' '%3d' "$__zrc")" 2>&1 ||
      'builtin' 'printf' '-v' '__zrc' '%3d' "$?"
    'builtin' 'unsetopt' 'multibyte'
    'builtin' 'printf' '%s%18d' "$__zrc" "${#__zrc}"
  )" || 'builtin' 'printf' '-v' '__zrc' '%3d%18d' "$?" '3'
  'builtin' 'emulate' '-L' 'zsh' '-o' 'no_multibyte'
  'builtin' 'local' '-i' n='__zrc[-18,-1]'
  'builtin' 'typeset' '-ga' 'reply'
  'builtin' 'set' '-A' 'reply' "$__zrc[-n-18,-22]" "$__zrc[1,-n-19]"
  'builtin' 'return' '__zrc[-21,-19]'
}

