#!/usr/bin/env bash

## find every vcf file
#find: -L option to include symlinks
find -L . \
  -type f \
  -name "*.fastq.gz" \
| sed 's#.fastq.gz#_fastqc.html#' \
| xargs mk
