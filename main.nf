#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { PREPROCESS } from './workflows/preprocess'

workflow {
    input_ch = Channel.fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> 
            def input_files = row.input_path.split(';').collect { it.trim() }
            [
                [
                    samplename: row.sample_name, 
                    down_size: row.down_size.toInteger(), 
                    output: row.output_path, 
                    is_paired: input_files.size() == 2
                ],
                input_files
            ]
        }

    input_ch.view { "Sample: $it" }

    PREPROCESS(input_ch)
}
