#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def helpMessage() {
    // TODO
    log.info """
    Please see here for usage information: https://github.com/cynapse-ccri/nf-troubleshooting/blob/main/docs/Usage.md
    """.stripIndent()
}

// Show help message
if (params.help) {
  helpMessage()
  exit 0
}

/*--------------------------------------------------------
  Defining and showing header with all params information
----------------------------------------------------------*/

// Header log info

def summary = [:]

if (workflow.revision) summary['Pipeline Release'] = workflow.revision

summary['Output dir']                                  = params.outdir
summary['Launch dir']                                  = workflow.launchDir
summary['Working dir']                                 = workflow.workDir
summary['Script dir']                                  = workflow.projectDir
summary['User']                                        = workflow.userName

// then arguments ******* EDIT THIS
summary['hello']                                       = params.hello


log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[2m--------------------------------------------------\033[0m-"

/*----------------------
  Setting up input data
-------------------------*/

// Define Channels from input
// only if not in dsl2

/*-----------
  Processes
--------------*/

process trivial_example {
    input:
        val(hello_thing)

    output:
        path 'greeting.txt', emit: greeting

    shell = ['/bin/bash', '-euo', 'pipefail']

    // this just creates files required to allow testing of a structure
    stub:
        """
        touch greeting.txt
        """

    // this is the work that does what you'd expect
    script:
        """
        echo "Hello ${hello_thing}" > greeting.txt
        """
}

workflow {
    main:
        trivial_example(params.hello)
}
