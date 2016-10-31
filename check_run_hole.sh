#!/bin/bash -l

# Check that run_hole.pl is working.

export RUNHOLE=`/bin/ps uax | grep ssh | grep -v uax | grep -v sshd | grep -v rsync | grep 2222`; 

<<<<<<< HEAD
if [[ ! $RUNHOLE ]]; then

    echo hole is not running;
    d=$(date);
    echo $d;
    /usr/bin/perl /home/ravi/run_hole.pl
fi;
=======
if [[ ! "$RUNHOLE" ]]; then
    echo "port 2222 is not running";
    d=$(date);
    echo $d;
    /usr/bin/perl /home/ravi/run_hole.pl
fi;
>>>>>>> 7e804b43a40cfa2c2dd7da3ebdd254bdbb2e9286
