__acquire_lock__() {
    if [[ -z $1 ]]; then
      echo No lock file name supplied;
      exit 1
    else
      if [ -f $1 ]; then
        echo $1 exists. Checking if the script still active
        local pid=$(cat $1)
        if ps -o args=  -p $pid | grep -q ${__SCRIPTNAME__}; then
            echo Script is active. Cannot acquire lock
            return 1
        else
            echo Script is not active. Cleaning up...
            rm $1
        fi
      fi
      echo $$ > $1;
      echo Acquired lock, $1 created;
      return 0
    fi
}

__release_lock__() {
    if [ -z $1 ]; then
      echo No lock file name supplied;
      exit 1
    else
      if [ -f $1 ]; then
        echo Releasing lock;
        rm $1;
        return 0
      else
        echo Lock file does not exist;
        return 0
      fi
    fi
}

trap 'if [[ ${__status__} == "ACTIVE" ]]; then __release_lock__ ${__LOCKFILE__}; fi'  EXIT
trap 'echo $BASH_COMMAND failed at $LINENO; exit' ERR

__ARGV__=$@
__HASH__=$(echo -n "${__ARGV__}" | md5sum 2>/dev/null | cut -f 1 -d " ")
__SCRIPTNAME__="${0##*/}"
__FILEPREFIX__=${__SCRIPTNAME__%%.*}
__LOCKFILE__=/tmp/${__FILEPREFIX__}_${ORACLE_SID}_${__HASH__}.lock
__status__="INACTIVE"

if ! __acquire_lock__ ${__LOCKFILE__}; then
  echo Instance of the script already running;
  exit 1;
fi

__status__='ACTIVE'

