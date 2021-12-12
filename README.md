# fastq_QC_processing
Short pipeline to analyze and modify fastq Quality

# Requierements

Compatible OS*:
Ubuntu 20.04 LTS

### Software

| Requierment | Version | Required Commands * |
|-------------|---------|---------------------|
|Java| v11.0.11 |java |
|Trimmomatic| v0.39 |java  -jar ILLUMINACLIP, AVGQUAL, LEADING, TRAILING, SLIDINGWINDOW, MINLEN|
| Fastqc |v0.11.9 | fastqc |
|Plan9port| Latest (as of 10/01/2019 ) | mk ** |
|R | v 4.1.2 | Rscript |
|pandoc | 2.5 | pandoc |

* These commands must be accessible from your $PATH (i.e. you should be able to invoke them from your command line).
** Plan9 port builds many binaries, but you ONLY need the mk utility to be accessible from your command line.

#### R packages requierments

| R package | Function |
|-----------|----------|
| rmarkdown | render |
| dplyr |magrittr, filter(), mutate(), select(), arrange() |
| knitr | kable|
| kableExtra | kable_styling |
| tidyr |pivot_longer() |
| scales | colour pallettes |
| ggplot2 | geom_col( ), ggplot() |
| cowplot | theme_cowplot() |
