#!/usr/bin/env bash
## This small script runs a module test with the sample data

###
## environment variable setting
export TRIM_AVGQUAL=30
export TRIM_LEADING=0
export TRIM_TRAILING=0
export TRIM_SLIDE_SIZE=6
export TRIM_SLIDE_QUAL=30
export TRIM_MINLEN=38
###

echo "[>..] test running this module with data in test/data"
## Remove old test results, if any; then create test/reults dir
rm -rf test/results
mkdir -p test/results
echo "[>>.] results will be created in test/results"
## Execute runmk.sh, it will find the basic example in test/data
## Move results from test/data to test/results
## results files are *.paired.fastq.gz and *.unpaired.fastq.gz *.trimlog.txt *.trimreport.txt
./runmk.sh \
&& mv test/data/*.trimreport.txt test/data/*.paired.fastq.gz test/data/*.unpaired.fastq.gz test/data/*.trimlog.txt test/results \
&& echo "[>>>] Module Test Successful"
