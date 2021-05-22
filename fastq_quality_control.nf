#!/usr/bin/env nextflow

/*================================================================
The AGUILAR LAB presents...

  The fastq QC processing Pipeline

- A fastq trimming and BEFORE and AFTER comparisson tool

==================================================================
Version: 0.0.1
Project repository: https://github.com/Iaguilaror/fastq_QC_processing
==================================================================
Authors:

- Bioinformatics Design
 Israel Aguilar-Ordonez (iaguilaror@gmail.com)

- Bioinformatics Development
 Israel Aguilar-Ordonez (iaguilaror@gmail.com)

- Nextflow Port
 Israel Aguilar-Ordonez (iaguilaror@gmail.com)

=============================
Pipeline Processes In Brief:
.
Pre-processing:
  _pre1_fastqc_before

Core-processing:
  _001_trimmomatic

Pos-processing
  _pos1_fastqc_after

Anlysis
 _an1_trimreport

================================================================*/

/* Define the help message as a function to call when needed *//////////////////////////////
def helpMessage() {
	log.info"""
  ==========================================
  The fastq QC processing Pipeline
  - A fastq trimming and BEFORE and AFTER comparisson tool
  v${version}
  ==========================================

	Usage:

  nextflow run fastq_quality_control.nf --input_dir <path to inputs> [--output_dir path to results ]

	  --input_dir    <- To-do;
				To-do;
				To-do;
	  --output_dir     <- directory where results, intermediate and log files will bestored;
				default: same dir where --query_fasta resides
	  -resume	   <- Use cached results if the executed project has been run before;
				default: not activated
				This native NF option checks if anything has changed from a previous pipeline execution.
				Then, it resumes the run from the last successful stage.
				i.e. If for some reason your previous run got interrupted,
				running the -resume option will take it from the last successful pipeline stage
				instead of starting over
				Read more here: https://www.nextflow.io/docs/latest/getstarted.html#getstart-resume
	  --help           <- Shows Pipeline Information
	  --version        <- Show Pipeline version
	""".stripIndent()
}

/*//////////////////////////////
  Define pipeline version
  If you bump the number, remember to bump it in the header description at the begining of this script too
*/
version = "0.0.1"

/*//////////////////////////////
  Define pipeline Name
  This will be used as a name to include in the results and intermediates directory names
*/
pipeline_name = "fastq_quality_control"

/*
  Initiate default values for parameters
  to avoid "WARN: Access to undefined parameter" messages
*/
params.input_dir = false  //if no inputh path is provided, value is false to provoke the error during the parameter validation block
params.help = false //default is false to not trigger help message automatically at every run
params.version = false //default is false to not trigger version message automatically at every run

/*//////////////////////////////
  If the user inputs the --help flag
  print the help message and exit pipeline
*/
if (params.help){
	helpMessage()
	exit 0
}

/*//////////////////////////////
  If the user inputs the --version flag
  print the pipeline version
*/
if (params.version){
	println "Pipeline v${version}"
	exit 0
}

/*//////////////////////////////
  Define the Nextflow version under which this pipeline was developed or successfuly tested
  Updated by iaguilar at MAY 2021
*/
nextflow_required_version = '20.10.0'
/*
  Try Catch to verify compatible Nextflow version
  If user Nextflow version is lower than the required version pipeline will continue
  but a message is printed to tell the user maybe it's a good idea to update her/his Nextflow
*/
try {
	if( ! nextflow.version.matches(">= $nextflow_required_version") ){
		throw GroovyException('Your Nextflow version is older than Pipeline required version')
	}
} catch (all) {
	log.error "-----\n" +
			"  This pipeline requires Nextflow version: $nextflow_required_version \n" +
      "  But you are running version: $workflow.nextflow.version \n" +
			"  The pipeline will continue but some things may not work as intended\n" +
			"  You may want to run `nextflow self-update` to update Nextflow\n" +
			"============================================================"
}

/*//////////////////////////////
  INPUT PARAMETER VALIDATION BLOCK
  TODO (iaguilar) check the extension of input queries; see getExtension() at https://www.nextflow.io/docs/latest/script.html#check-file-attributes
*/

/* Check if inputs provided
    if they were not provided, they keep the 'false' value assigned in the parameter initiation block above
    and this test fails
*/
if ( !params.input_dir ) {
  log.error " Please provide the following params: --input_dir \n\n" +
  " For more information, execute: nextflow run fastq_quality_control.nf --help"
  exit 1
}

/*
Output directory definition
Default value to create directory is the parent dir of --input_dir
*/
params.output_dir = file(params.input_dir).getParent()

/*
  Results and Intermediate directory definition
  They are always relative to the base Output Directory
  and they always include the pipeline name in the variable (pipeline_name) defined by this Script

  This directories will be automatically created by the pipeline to store files during the run
*/
results_dir = "${params.output_dir}/${pipeline_name}-results/"
intermediates_dir = "${params.output_dir}/${pipeline_name}-intermediate/"

/*
Useful functions definition
*/

/*//////////////////////////////
  LOG RUN INFORMATION
*/
log.info"""
==========================================
The fastq QC processing Pipeline
- A fastq trimming and BEFORE and AFTER comparisson tool
v${version}
==========================================
"""
log.info "--Nextflow metadata--"
/* define function to store nextflow metadata summary info */
def nfsummary = [:]
/* log parameter values beign used into summary */
/* For the following runtime metadata origins, see https://www.nextflow.io/docs/latest/metadata.html */
nfsummary['Resumed run?'] = workflow.resume
nfsummary['Run Name']			= workflow.runName
nfsummary['Current user']		= workflow.userName
/* string transform the time and date of run start; remove : chars and replace spaces by underscores */
nfsummary['Start time']			= workflow.start.toString().replace(":", "").replace(" ", "_")
nfsummary['Script dir']		 = workflow.projectDir
nfsummary['Working dir']		 = workflow.workDir
nfsummary['Current dir']		= workflow.launchDir
nfsummary['Launch command'] = workflow.commandLine
log.info nfsummary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "\n\n--Pipeline Parameters--"
/* define function to store nextflow metadata summary info */
def pipelinesummary = [:]
/* log parameter values beign used into summary */
pipelinesummary['trimmomatic: avgqual']			= params.trim_avgqual
pipelinesummary['trimmomatic: leading']			= params.trim_leading
pipelinesummary['trimmomatic: trailing']			= params.trim_trailing
pipelinesummary['trimmomatic: slide size']			= params.trim_slide_size
pipelinesummary['trimmomatic: slide qual']			= params.trim_slide_qual
pipelinesummary['trimmomatic: minlen']			= params.trim_minlen
pipelinesummary['input directory']			= params.input_dir
pipelinesummary['Results Dir']		= results_dir
pipelinesummary['Intermediate Dir']		= intermediates_dir
/* print stored summary info */
log.info pipelinesummary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "==========================================\nPipeline Start"

/*//////////////////////////////
  PIPELINE START
*/



/*
	READ INPUTS
*/

/* Define function for finding files that share sample name */
/* in this case, the file name comes from the 1st ".",
since tokenize array starts at 0, array index shoould be 0 */
def get_sample_prefix = { file -> file.name.toString().tokenize('R')[0] }

/* Load fq files into channel as pairs */
Channel
  .fromPath( "${params.input_dir}/*.fastq.gz" )
  .map{ file -> tuple(get_sample_prefix(file), file) }
	.groupTuple()
  // .view()
  .into{ fastq_inputs; fastq_inputs_again }

/* _pre1_fastqc_before */
/* Read mkfile module files */
Channel
	.fromPath("${workflow.projectDir}/mkmodules/mk-fastqc/*")
	.toList()
	.set{ mkfiles_pre1 }

process _pre1_fastqc_before {

	publishDir "${results_dir}/_pre1_fastqc_before/",mode:"copy"

	input:
  set val( sample_name ), file( sample ) from fastq_inputs
	file mk_files from mkfiles_pre1

	output:
	file "*" into results_pre1_fastqc_before

	"""
	bash runmk.sh
	"""

}

/* 	Process _001_trimmomatic */
/* Read mkfile module files */
Channel
	.fromPath("${workflow.projectDir}/mkmodules/mk-trimmomatic/*")
	.toList()
	.set{ mkfiles_001 }

process _001_trimmomatic {

	publishDir "${results_dir}/_001_trimmomatic/",mode:"copy"

	input:
	set val( sample_name ), file( sample ) from fastq_inputs_again
	file mk_files from mkfiles_001

	output:
	file "*.fastq.gz" into results_001_trimmomatic_trimmed_fq
  file "*.trimlog.txt" into results_001_trimmomatic_trimlog
	file "*.trimreport.txt" into results_001_trimmomatic_trimreport

	"""
  export TRIM_AVGQUAL="${params.trim_avgqual}"
  export TRIM_LEADING="${params.trim_leading}"
  export TRIM_TRAILING="${params.trim_trailing}"
  export TRIM_SLIDE_SIZE="${params.trim_slide_size}"
  export TRIM_SLIDE_QUAL="${params.trim_slide_qual}"
  export TRIM_MINLEN="${params.trim_minlen}"
	bash runmk.sh
	"""

}

/* gather all trimreport.txt files */
results_001_trimmomatic_trimreport
	.toList()
	// .view()
	.set{ all_trimreports }

/* 	Process _an1_trimreport */
/* Read mkfile module files */
Channel
	.fromPath("${workflow.projectDir}/mkmodules/mk-trimreport/*")
	.toList()
	.set{ mkfiles_an1 }

process _an1_trimreport {

	publishDir "${results_dir}/_an1_trimreport/",mode:"copy"

	input:
	file reports from all_trimreports
	file mk_files from mkfiles_an1

	output:
	file "*.pdf"

	"""
	bash runmk.sh
	"""

}
