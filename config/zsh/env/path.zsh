# Remove duplicate entries from path arrays and their associated
# colon-separated scalars, and make sure these are all flagged for export
typeset -gxTU  FPATH        fpath
typeset -gxTU  PATH         path
typeset -gxTU  MANPATH      manpath
typeset -gxTU  INFOPATH     infopath
typeset -gxTU  PERLLIB      perllib

# Clean up path arrays: expand symlinks and remove non-existent and empty
# directories.  Duplicate entries are removed by having set the `-U` attribute
# for these arrays.
cleanup-path-array() {
  readonly varname=$1
  shift
  
  # ${^...}       - Applies expansion as if to an array
  #
  #                 For example, given `x=(1 2 3)`, `a${x}b`
  #                 expands to `a1 2 3b`, while `a${^x}b` expands
  #                 to `a1b a2b a3b`.
  #                 
  #                 (man zshexpn -> PARAMETER EXPANSION)
  #                 
  # ${(P)varname}   Expands to the value of the variable named by $varname,
  #                 similar to $(eval "echo $varname"), but without requiring a
  #                 subshell
  #                 
  #                 (man zshexpn -> PARAMETER EXPANSION -> Parameter Expansion
  #                 Flags)
  #                 
  # ${...:A}        Turns a file name into an absolute path and resolve symbolic
  #                 links
  #                 
  #                 (man zshexpn -> HISTORY EXPANSION -> Modifiers)
  #                 
  # (N-F)           Set NULL_GLOB and restrict to non-empty directories
  #                 (checking symlink targets)
  #                 
  #                 (man zshexpn -> FILENAME GENERATION -> Glob Qualifiers)
  
  set -A $varname ${^${(P)varname}:A}(N-F)
}

fpath=(
  $ZDOTDIR/env/functions
  $fpath
)
cleanup-path-array fpath

path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/.cabal/bin
  $HOME/.export/bin
  $HOME/.export/npm/bin
  $HOME/.local/lib/ruby/gems/*/bin
  $HOME/.gem/bin
  # Remove /usr/local/links/bin from the path
  # - doesn't have anything I use
  # - has 8k+ entries, which can take a long time to hash if stat() calls take a
  #   long time (which occasionally they do)
  #
  # Useful items can be symlinked in .local/bin
  ${(@)path:#/usr/local/links/bin}
)
cleanup-path-array path

manpath=(
  $HOME/.local/share/man
  $HOME/.cabal/share/man
  /export/data/nleaste/npm/share/man
  /export/data/nleaste/share/man
  $manpath
)
cleanup-path-array manpath

infopath=
  $HOME/.local/share/info
  /export/data/nleaste/share/info
  $infopath
)

ld_library_path=(
  $HOME/.export/lib
  $HOME/.local/lib
  $ld_library_path
)
cleanup-path-array ld_library_path

perllib=(
  $HOME/Tools
  $HOME/Documents/Code/Perl
  $perllib
)
cleanup-path-array perllib
