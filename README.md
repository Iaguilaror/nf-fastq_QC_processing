# fastq_QC_processing
Short pipeline to analyze and modify fastq Quality

# Requierements 

Compatible OS*:
ññññ

### Software

| Requierment | Version | Required Commands * |
|-------------|---------|---------------------|
|Java| v11.0.11 |java |
|Trimmomatic| v0.39 |java  -jar ILLUMINACLIP, AVGQUAL, LEADING, TRAILING, SLIDINGWINDOW, MINLEN|
| Fastqc |v0.11.9 | fastqc |
|Plan9port| Latest (as of 10/01/2019 ) | mk ** |
|R | v 4.1.2 | Rscript |

* These commands must be accessible from your $PATH (i.e. you should be able to invoke them from your command line).
** Plan9 port builds many binaries, but you ONLY need the mk utility to be accessible from your command line.
