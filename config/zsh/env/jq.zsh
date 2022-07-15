# Alter the colors jq uses when coloring
#
# Order is
#   null:false:true:number:string:array:object
#
# Default (if not given) is:
#   1;30:0;37:0;37:0;37:0;32:1;37:1;37
#
typeset -xT JQ_COLORS jq_colors

jq_colors=(
  1       # null    [override] default "1;30" is invisible on black background
  "0;37"  # false   [default]
  "0;37"  # true    [default]
  "0:37"  # number  [default]
  "0;32"  # string  [default]
  "1;37"  # array   [default]
  "1;37"  # object  [default]
)

# A wrapper around `jq` that prints the input on failure
jq() (
  input=$(mktemp)
  cleanup() {
    if [ $? -ne 0 ] && [ -f $input ]; then
      >&2 echo -n $'\e[31m'
      >&2 cat $input
      >&2 echo -n $'\e[m'
    fi
    rm -f $input
  }
  trap 'cleanup' EXIT
  tee $input | command jq "$@"
)
