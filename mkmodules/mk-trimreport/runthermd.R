# This script exists as an interface to pass parameters to RMD in an ordered manner

## Read args from command line
args = commandArgs(trailingOnly=TRUE)

## Uncomment For debugging only
## Comment for production mode only
args[1] <- "all_samples_trim_report.pdf" ## all_samples_trim_report.pdf files

## Passing args to named objects
pdf_file <- args[1]
rmd_file <- "trim_plot.Rmd" # maybe add manually always?

# call the renderizer
rmarkdown::render( input = rmd_file,
                   output_file = pdf_file,
                   output_dir = getwd(), # if we dont fix the wd here, knit will fail when NF tries to execute it from a different workdir
                   intermediates_dir = getwd(), # if we dont fix the wd here, knit will fail when NF tries to execute it from a different workdir
                   knit_root_dir = getwd() ) # if we dont fix the wd here, knit will fail when NF tries to execute it from a different workdir
