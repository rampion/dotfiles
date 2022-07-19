# define the module function
source /usr/share/Modules/init/zsh

# useful for spitting out warnings in other functions
local warn='1>&2 echo -e "\e[33mWARNING:\e[m"'

# Link the module environment variables to some arrays for ease of use
if ! (( ${+loadedmodules} )); then
  typeset -TU LOADEDMODULES loadedmodules
fi

if ! (( ${+modulepath} )); then
  typeset -TU MODULEPATH modulepath
fi

checked-module-use() {
  readonly new_modules_dir=$1
  shift
  
  local module_file
  local modules_dir
  
  # check that modules in new_modules_dir are up to date
  find $new_modules_dir -type f -printf $'%P\n' | while read module_file ; do
    for modules_dir in $modulepath; do
      if [ -f "$modules_dir/$module_file" ] && [ "$modules_dir/$module_file" -nt "$new_modules_dir/$module_file" ]; then
        eval $warn "module definition for $module_file in $new_modules_dir overrides newer definition in $modules_dir"
        break
      fi
    done
  done

  # prepend it to the MODULEPATH
  module use $new_modules_dir
}
checked-module-use $HOME/.local/modules

module-load-latest() {
  # `module` is slow, sow we'll avoid calls where possible:
  #
  # - check $modulepath to discover the latest_modules rather than grepping
  #   `module avail`
  #
  # - check $loadedmodules to see if any new modules need to be loaded rather than
  #   unconditionally running `module load $latest_modules`
  #
  # - check $loadedmodules to see if any old modules need to be unloaded rather
  #   than unconditionally running `module unload "$@"`
  
  local module_version
  local -a latest_modules
  local module_specifier
  for module_specifier in "$@"; do
  
    if [[ $module_specifier =~ /[[:digit:]] ]]; then
      # sometimes we do want a specific version
      latest_modules+=$module_specifier
    elif
      # assume module_specifier is just a module name
      #
      # ${~GLOB}            interpret parameter expansion of GLOB as a glob
      # ARRAY[@]/%/SUFFIX   append SUFFIX to each element of ARRAY
      # EXPANSION()         force interpretation of EXPANSION as a glob
      local -a module_roots
      modulue_roots=(${~modulepath[@]/%//${module_specifier}()}
      
      # find ... printf %P  print relative path, skipping any unreadabel
      #                     directories (looking at you, /opt/local/sys/modules/firefox)
      (( $#module_roots )) &&
      find $module_roots ! -readable -prune -or -type f -name '[[:digit:]]*' -printf $'%P\n' |
      sort -Vr |
      read module_version
    then
      latest_modules+="${module_specifier}/${module_version}"
    else
      eval $warn "unable to locate latest $module_specifier module, falling back to default"
      latest_modules+=$module_specifier
    fi
  done
  
  local -a new_modules
  new_modules=(${latest_modules:|loadedmodules}) # :| - difference of arrays
  
  if (( $#new_modules )); then
    local -a new_module_names
    new_module_names=(${new_modules:h})
    
    local -a loadedmodule_names
    loadedmodule_names=(${loadedmodules:h})
    
    local -a updated_modules
    updated_modules=(${loadedmodule_names:*new_module_names}) # :* - intersection of arrays
    
    # having multiple versions of the same module can result in incompatibility
    # warnings, so unload other versions of modules we're going to load
    if (( $#updated_modules )); then
      # unload in reverse order, missing dependencies can prevent unloading
      module unload "${(Oa)updated_modules[@]}"
    fi
    
    module load "${new_modules[@]}"
  fi
}

# maven objects if any version of java is loaded; it expects to load
# java 1.8 itself and has issues with later versions of java :(
if [[ ${loadedmodules[(i)java*]} -le ${#loadedmodules} ]]; then
  module unload java
fi

# see `module avail` for a list of available modules
local -a module_list
module_list=(
  ffmpeg
  firefox
  gcc
  git
  imagemagick
  llvm
  module-provides
  node
  openssl
  python3/3.10.0
  ruby
  rust
  sbt
  maven
  sqlite3
  thunderbird
  tmux
  vim
)
module-load-latest $module_list
