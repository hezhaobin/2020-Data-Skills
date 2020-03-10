#!/bin/bash

# Specify the queue to use
#! -q all.q

# give a name to the job, default to script name
#$ -N test

# execute the job from the current working directory
#$ -cwd

# specify the file names for redictring the output and error messages
#$ -o test.out
#$ -e test.err

# Send e-mail at beginning/end/suspension of job
#$ -m bes

# E-mail address to send to
#$ -M <HawkID>@uiowa.edu

# good options to set for reproducibility
# remember them from our bash class?
set -e
set -u
set -o pipefail

# Print information from the job into the output file
/bin/echo Running on compute node: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

# Sleep (wait and do nothing) for 30 seconds
sleep 30

# Print the end date of the job before exiting
echo Now it is: `date`

#Now try something that shouldn't work, so that an error will be written to the error file
echo A variable that is does not exist should give an error $NOTSET

exit
