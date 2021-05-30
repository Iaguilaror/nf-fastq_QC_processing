#!/bin/bash

inputdir="../../real-data/8paired_samples_montpe/"
number_of_reads="4000"

for ifile in $(ls $inputdir/*.fastq.gz)
do
	file_name=$(basename $ifile)
	ofile=$(echo $file_name | sed -e "s#Barreto#Lab#" -e "s#Montpellier#somewhere#" )
	echo "[>..] Sampling $file_name"
	echo "[.>.] into $ofile"
	seqtk sample -s100 $ifile $number_of_reads | bgzip > $ofile
done
