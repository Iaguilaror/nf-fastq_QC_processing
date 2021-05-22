input_dir="real-data/8paired_samples_montpe/"
output_directory="$input_dir/results"

nextflow run fastq_quality_control.nf \
	--input_dir $input_dir \
	--output_dir $output_directory \
	-resume \
	-with-report $output_directory/`date +%Y%m%d_%H%M%S`_report.html \
	-with-dag $output_directory/`date +%Y%m%d_%H%M%S`.DAG.html
