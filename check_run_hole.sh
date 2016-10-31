#!/bin/bash -l

# Check that run_hole.pl is working.

export RUNHOLE=`/bin/ps uax | grep ssh | grep -v uax | grep -v sshd | grep -v rsync | grep 2222`; 

if [[ ! $RUNHOLE ]]; then

    echo hole is not running;
    d=$(date);
    echo $d;
    /usr/bin/perl /home/ravi/run_hole.pl
fi;