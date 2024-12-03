#!/usr/bin/env nextflow

input_ch = Channel.fromPath( params.input )
                    .splitCsv( header: true)
                    .map { row -> tuple(samplename = row.sample_name, down_size = row.down_size, input = row.input_path, output = row.output_path) }
                    
process DOWNSAMPLING {
    debug true
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/seqtk:r132'
    tag "$samplename"
    publishDir "$output", mode: 'copy'

    input:
    tuple val(samplename), val(down_size), path(input), path(output)

    output:
    tuple val(samplename), path("${samplename}_R1_sub.fastq.gz"), emit: fq

    script:
    """
    echo "Sample Name $samplename"
    echo "Down Size $down_size"
    seqtk sample -s100 $input $down_size > ${samplename}_sub.fastq
    pigz ${samplename}_R1_sub.fastq
    """
}

workflow PREPROCESS {
    take:
    input_ch
 
    main:
    //DOWNSAMPLING( input_ch )
    input_ch.view()
}


workflow NEGEDIA {
    PREPROCESS( input_ch )
}

workflow {
    NEGEDIA ()
}
