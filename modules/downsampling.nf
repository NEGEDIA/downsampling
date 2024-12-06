process DOWNSAMPLING {
    tag "$meta.samplename"
    publishDir "${params.outdir}/${meta.output}", mode: 'copy'

    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/seqtk:r132'

    input:
    tuple val(meta), path(input_files)

    output:
    tuple val(meta.output), val(meta.samplename), path("${meta.samplename}_sub*.fastq.gz"), emit: fq

    script:
    def seqtk_cmd = seqtkCommand(meta.samplename, meta.down_size, input_files, meta.is_paired)
    """
    echo "Debug: meta = ${meta}"
    echo "Debug: Input files = ${input_files}"
    
    # List the contents of the current directory
    echo "Current directory contents:"
    ls -la

    $seqtk_cmd

    pigz ${meta.samplename}_sub*.fastq
    """
}

def seqtkCommand(samplename, down_size, input_files, is_paired) {
    if (is_paired) {
        """
        seqtk sample -s100 ${input_files[0]} $down_size > ${samplename}_sub_1.fastq
        seqtk sample -s100 ${input_files[1]} $down_size > ${samplename}_sub_2.fastq
        """
    } else {
        "seqtk sample -s100 ${input_files[0]} $down_size > ${samplename}_sub.fastq"
    }
}