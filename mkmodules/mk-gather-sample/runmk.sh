#!/usr/bin/env bash

## find every fq file
#find: -L option to include symlinks
find -L . \
  -type f \
  -name "*fastq.gz" \
| sed \
  -e 's#.unpaired.fastq.gz##' \
  -e 's#.paired.fastq.gz##' \
  -e 's#_R[1-2]##' \
  -e 's#$#.allreads.fastq#' \
| sort -u \
| xargs mk
