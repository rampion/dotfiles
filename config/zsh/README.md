Contains config files for the `zsh` shell.

## Config file order

According to `zsh -o sourcetrace`:

1. `/etc/zshenv`

2. `$HOME/.zshenv`

    - `$ZDOTDIR/.zshenv` symlinks to `$ZDOTDIR/env.zsh`

3. If run as a login shell (with `-l`), e.g. when a new terminal is created:

    - `/etc/zprofile`
    - `/etc/profile`

  Otherwise, for sub-shells and new tmux windows:
  
    - `/etc/zshrc`

4. `/etc/profile.d/*`
5. If run as a login shell (with `-l), e.g. when a new terminal is created:

    - `/etc/profile.d/sh.local`
    - `$ZDOTDIR/.zprofile` symlinks to `$ZDOTDIR/profile.zsh`
    - `/etc/zshrc`

6. `$ZDOTDIR/.zshrc` symlinks to `$ZDOTDIR/rc.zsh`
7. If run as a login shell (with `-l`), e.g. when a new terminal is created:

    - `/etc/zlogin`
    - `$ZDOTDIR/.zlogin` symlinks to `ZDOTDIR/login.zsh`

## Profiling

If shell startup seems slow, we can profile it with `zprof`

- add `zmodload zsh/zprof` to `~/.zshenv` to enable profiling as early as possible
- run `zsh - i -c zprof` to see the shell startup profiling costs
