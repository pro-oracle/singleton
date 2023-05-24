# singleton
Implementation of a Singleton Script in Bash

Usage:
    Source the script into your script, e.g.

    #!/bin/bash
    source singleton.sh
  
singleton.sh is a utility script aimed to help in implemention of singleton scripts in bash.

Features:
* input parameters awareness, that is, "somescript.sh p1 p2" and "somescript.sh p1 p3" will be allowed to run simultaneously, but two "somescript.sh p1 p2" invocations will not run at the same time, the second invocation will fail
* automatic lock files clean up after abnormal script interruption  

