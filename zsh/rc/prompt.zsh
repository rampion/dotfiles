# Defines a custom dual-sided prompt, with a colored glyph on the left
# indicating the version control state and more information on the right that
# vanishes when anything is typed at the prompt.
#
# If the previous command returned nonzero, a header line displays the error
# code.
#
# In the HOME directory, as a special case, it will use ~/.files as the GIT_DIR.
#
# The glyph color meanings:
#
#   $ (gray)     - the current directory is not tracked by git
#   % (green)    - the git checkout is clean
#   @ (orange)   - the git checkout contains unstaged changes/files
#   & (yellow)   - the git checkout contains staged changes/files
#
# On the right-hand side is listed:
#
#   - the root of the git repos (cyan)
#   - the current branch name (color matches the glyph, bold)
#   - the current git action (if any) (white, bold)
#   - the subdirectory within the repos
#
# Examples:
#
# 1) The current directory is ~/Documents, which is not under version control.
#
#     prompt: $                                       [~/Documents]
#     cursor:   ^
#
# 2) The current directory is ~/Projects/foo, which is managed by git. The
#    GIT_DIR is ~/Projects/foo/.git, the current branch is master, and the
#    checkout is clean. No action is currently being performed.
#
#     prompt: $                             [~/Projects/foo#master]
#     cursor:   ^
#
# 3) The current directory is ~/Projects/foo/bar/baz, which is managed by git.
#    The GIT_DIR is ~/Projects/foo/.git, the current branch is master, and the
#    checkout is clean. No action is currently being performed.
#
#     prompt: $                     [~/Projects/foo#master/bar/baz]
#     cursor:   ^
#
# 4) The currend directory is ~/Projects/foo/bar/baz, which is managed by git.
#    The GIT_DIR is ~/Projects/foo/.git, the current branch is master, and the
#    checkout is clean. A `git rebase -i` is underway.
#
#     prompt: $           [~/Projects/foo#master(rebase-i)/bar/baz]
#
# 5) The current directory is ~/Projects/foo, which is managed by git. The
#    GIT_DIR is ~/Projects/foo/.git, the current branch is master, and the
#    checkout contains unstaged changes. No action is currently being performed.
#
#     prompt: @                             [~/Projects/foo#master]
#
# 6) The current directory is ~/Projects/foo, which is managed by git. The
#    GIT_DIR is ~/Projects/foo/.git, the current branch is master, and the
#    checkout contains staged changes. No action is currently being performed.
#
#     prompt: &                             [~/Projects/foo#master]
#
# 7) The current directory is ~/Documents, which is not under version control.
#    The previous command, "foo -n bar", returned 5.
#
#     prompt:   $?=5 foo -n bar                               ERROR
#             $                                       [~/Documents]
#     cursor:   ^

################################################################################

local glyph=➤

# NOTE: PROMPT_SUBST is needed for parameter and arithmetic expansion of $PARAM,
#       ${PARAM}, $(CMD), and $((MATH)) when the prompt is used
local -a prompt_parts
prompt_parts=(
  # if the prior command failed, print its exit status on a separate line first
  '%(?::'           # when $? != 0
    '%K{196}'         # background ← bright red
    '%B'              # text ← bold
    '%(?::%$(($COLUMNS-7))>>'
                      # truncate contents to leave 7 unfilled columns
                        # HACK: The conditional is always true, but it is the
                        #       only way to stop the truncation before the next
                        #       part of the prompt.
      '%{ %F{11}%}'     #  foreground ← bright yellow
      ' \$?=%?'         # show the error status
      '%{ %F{white}%}'  # foreground ← white
      '$(history -n -1 | sed "s/[)%]/%&/g")'
                        # print the prior command (with prompt escapes escaped)
      '${(l:COLUMNS:)__nothing__+}'
                        # fill the rest of the line with spaces, so the
                        # remainder is right-justified
                        # (__nothing__ is an arbitrary variable assumed to be
                        # unpopulated)
    ')'               # /truncation
    '%F{11}'          # foreground ← bright yellow
    ' ERROR '
    '%f'              # foreground ← default
    '%b'              # text ← normal
    '%k'              # background ← default
    $'\n'
  ')'
  '%F{${vcs_info_msg_0_:-245}}'
                      # foreground ← color set by vcs_info (default to 245/grey)
  '%{'
    $glyph '%G'       # tell prompt $glyph is only one character wide
  '%}'
  '%f'                # foreground ← default
  ' '
)
# concatenate the entries in $prompt to get PROMPT
export PROMPT=${(j::)prompt_parts}

# PROMPT2 is used for multiline commands
export PROMPT2='%F{245}…%f '

# show the status of the parser (%_) in the RPROMPT for continuation lines
# (padded to left-justify the parser state)
export RPROMPT2=$'%$((COLUMNS-2))>>%F{245}%_%f${(l:COLUMNS:)__nothing__+}'

local -a rprompt_parts
rprompt_parts=(
  '%{'
    '%F{245}'            # foreground ← light grey
  '%}'
  # ${${EXPN:+TRUE}:-FALSE}
  #   a kind of ternary operator for parameter
  #   expansion.
  #
  #   if $EXPN expands to non-empty, ${${VAR:+TRUE}:-FALSE} expands to "TRUE"
  #
  #   if $EXPN expands to empty, ${${VAR:+TRUE}:-FALSE} expands to "FALSE"
  '${${vcs_info_msg_1_:+'         # if vcs_info_msg_1_ is non-empty
    '${vcs_info_msg_1_}'            # %R - path to base of git project
    '%{%F{$vcs_info_msg_0_\}%\}'    # closing } for %F and %{ must be escaped to not
                                    # end parameter-expansion ${... above
    '#${vcs_info_msg_2_}'           # %b - git branch name
    '%{%F{magenta\}%\}'
    '${'
      'vcs_info_msg_3_'             # %a - git action name
      ':+'                          # if set
      '($vcs_info_msg_3_)'          # '(action)'
    '}'
    '%{%F{14\}%\}'
    '${vcs_info_msg_4}'             # %a - git subdirectory
  '}:-'                           # otherwise, we're not in a git repository
    '${(D)PWD}'                     # current path
                                    # (D) - abbreviate the current working directory using
                                    #       directory names (like ~)
                                    #       see the AUTO_NAME_DIRS option
  '}'
)
# RPROMPT:
export RPROMPT=${(j::)rprompt_parts}
setopt TRANSIENT_RPROMPT # hide rprompt from previous commands

# to poulate the vcs_info_msg_*_ variables, we need to run the vcs_info
# function before the prompt renders (precmd)
autoload -Uz vcs_info add-zsh-hook
add-zsh-hook precmd vcs_info

# only check if git is being used
zstyle ':vcs_info:*' enable git

# vcs_info doesn't check for changes by default, it must be told to do so
zstyle ':vcs_info:*' check-for-changes true

# just use "1" or "" when detecting staged/unstaged changes, so we can
# use the %N(X:if-true:if-false) zformat construct (renders if-true when %X = N,
# renders if-false otherwise)
zstyle ':vcs_info:*' stagedstr
zstyle ':vcs_info:*' unstagedstr 1
zstyle ':vcs_info:*' max-exports 5

# used when no vcs detected (doesn't work in zsh-5.2, upgrade to fix)
# WORKAROUND: use ${vcs_info_msg_0_:-NO_VCS_VALUE} in PROMPT/RPROMPT
#zstyle ':vcs_info:*' nvcsformats '245' '%~'

# the formats are what determine the vcs_info_msg_*_ content
#
#   vcs_info_msg_0_ - the glyph color
#     'c' expands to the value of 'stagedstr'
#         '1' if any staged changes
#         '' if not
#     'u' expands to the value of 'unstagedstr'
#         '1' if any unstaged changes
#         '' if not
#
#     11 (yellow) - staged changes
#     9 (red)     - unstaged changes
#     10 (green)  - clean checkout
#     245 (gray)  - not under version control
local format_vcs_info_msg_0_=$'%1(c:11:%1(u:9:10))'
local format_vcs_info_msg_1_="%R" # - base a git project
local format_vcs_info_msg_2_="%b" # - git branch name
local format_vcs_info_msg_3_="%a" # - action name
local format_vcs_info_msg_4_="%S" # - subdirectory w/in git project

# used when vcs detected
zstyle ':vcs_info:*' formats $format_vcs_info_msg_0_ $format_vcs_info_msg_1_ $format_vcs_info_msg_2_ $format_vcs_info_msg_3_ $format_vcs_info_msg_4_
# used during rebase/merge/etc

zstyle ':vcs_info:*' actionformats $format_vcs_info_msg_0_ $format_vcs_info_msg_1_ $format_vcs_info_msg_2_ $format_vcs_info_msg_3_ $format_vcs_info_msg_4_

zstyle ':vcs_info:*+post-backend:*' hooks zshprompt-post-backend
+vi-zshprompt-post-backend(){
  if (( ${+hook_com[base]} )) ; then
    # make %R%S is the same as %~
    # 1) abbreviate the base directory using ~ for $HOME
    #hook_com[base]=$(print -rD ${hook_com[base]});
    # XXX bug in zsh-5.0 causes this to print as ~gitbase (literally)
    # XXX workaround
    hook_com[base]=$(echo ${hook_com[base]} | sed "s;$HOME;~;")
    
    # 2) abbreviate the subdirectory using "" for .
    if [ "${hook_com[subdir]}" = "." ] ; then
      hook_com[subdir]=""
    else
      hook_com[subdir]="/${hook_com[subdir]}"
    fi
    
    # mark untracked files as "unstaged changes" (by default only
    # changed tracked files count) (stolen from
    # https://github.com/zsh-user/zsh/blob/master/Misc/vcs_info-examples#L161)
    if git status --porcelain | grep '??' &> /dev/null ; then
      hook_com[unstaged]='1'
    fi
  fi
}
