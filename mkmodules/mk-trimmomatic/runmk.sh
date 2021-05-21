#!/usr/bin/env bash

## find every vcf file
#find: -L option to include symlinks
find -L . \
  -type f \
  -name "*R1.fastq.gz" \
| sed 's#.fastq.gz$#.paired.fastq.gz#' \
| xargs mk
