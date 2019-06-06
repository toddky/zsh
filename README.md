
My zsh Config
================================================================================

Startup/Shutdown Files
--------------------------------------------------------------------------------

### `.zshenv`

* Set `$PATH` and variables that frequently change
* Always sourced for interactive and non-interactive shells.


### `.zprofile`

* Sourced for login shells
* Set variables that rarely change
* Slow commands that setup the environment


### `.zshrc`

* Sourced for interactive usage
* Used for setting
  * Prompt
  * History options
  * Command completion/correction/suggestion
  * Aliases
  * Key-bindings


### `.zlogin`

* Sourced for login shells
* Similar to `.zprofile` but read after `.zshrc`


### `.zlogout`

* Sourced at logout in the login shell
* Clear/free resources

