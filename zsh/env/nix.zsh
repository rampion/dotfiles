# Overwrite the nix-shell command
function nix-shell () {
  .any-nix-shell-wrapper zsh "$@"
}

# Override version from any-nix-shell to remove ANSI escaped highlighting
function nix-shell-info() {
  if [[ ${IN_NIX_SHELL-} != "" ]] || [[ ${IN_NIX_RUN-} != "" ]]; then
      output=$(echo $ANY_NIX_SHELL_PKGS | xargs)
      if [[ -n $name ]] && [[ $name != shell ]]; then
          output+=" "$name
      fi
      if [[ -n $output ]]; then
          output=$(echo $output ${additional_pkgs-} | tr ' ' '\n' | sort -u | tr '\n' ' ' | xargs)
          printf "$output"
      else
          printf "[unknown environment]"
      fi
  fi
}
