#!/usr/bin/env bash
## This small script runs a module test with the sample data

###
## environment variable setting
export trim_avgqual=30
export trim_leading=0
export trim_trailing=0
export trim_slide_size=6
export trim_slide_qual=30
export trim_minlen=38
###

echo "[>..] test running this module with data in test/data"
## Remove old test results, if any; then create test/reults dir
rm -rf test/results
mkdir -p test/results
echo "[>>.] results will be created in test/results"
## Execute runmk.sh, it will find the basic example in test/data
## Move results from test/data to test/results
## results files are *.paired.fastq.gz and *.unpaired.fastq.gz
./runmk.sh \
&& mv test/data/*.paired.fastq.gz test/data/*.unpaired.fastq.gz test/data/*.trimlog.txt test/results \
&& echo "[>>>] Module Test Successful"
