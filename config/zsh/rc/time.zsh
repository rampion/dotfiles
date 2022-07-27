# how long in seconds a command needs to run in order to be auto-`time`d
REPORTTIME=3

# used by implicit/explicit calls to `time`
TIMEFMT=$'\e[30m# \e[36m%J\e[m  \e[33m%U\e[m user \e[33m%S\e[m system \e[33m%P\e[m cpu \e[33m%E\e[m total'
