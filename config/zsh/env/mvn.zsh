# mvnq = [mvn], [q]uieter (w/o INFO)
alias mvnq="mvn -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"

# mvnp = [mvn] w/ [p]rogress
function mvnp {
  # show progress, and save info to a logfile
  local logfile="$HOME/.m2/logs/${PWD:t}.$(date +%FT%T)"
  mkdir -p $(dirname $logfile)
  echo "mvnp $@" > logfile
  mvn $@ | tee -a $logfile | awk --posix -f $ZDOTDIR/env/mvnp.awk
  return $pipestatus[1]
}
