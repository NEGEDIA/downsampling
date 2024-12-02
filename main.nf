#!/usr/bin/env nextflow

input_ch = Channel.fromPath( params.input )
                    .splitCsv( header: true)
                    .map { row -> tuple(samplename = row.sample_name, down_size = row.down_size, input = row.input_path, output = row.output_path) }

process DOWNSAMPLING {
    debug true
    tag "$samplename"
    publishDir "$output", mode: 'copy'

    input:
    tuple val(samplename), val(down_size), path(input_path), path(output_path)

    output:
    path("*.fastq.gz")

    script:
    """
    echo "Sample Name $samplename"
    echo "Down Size $down_size"
    touch ${samplename}.fastq.gz
    """
    
}

workflow PREPROCESS {
    take:
    input_ch
 
    main:
    DOWNSAMPLING( input_ch )
}


workflow NEGEDIA {
    PREPROCESS( input_ch )
}

workflow {
    NEGEDIA ()
}