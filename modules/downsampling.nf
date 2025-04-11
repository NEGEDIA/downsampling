process DOWNSAMPLING {
    debug true
    tag "$meta.samplename"
    publishDir "${params.outdir}/${meta.output}", mode: 'copy'
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/bbmap:39.06'

    input:
    tuple val(meta), path(input_files)

    output:
    tuple val(meta.output), val(meta.samplename), path("${meta.samplename}_sub*.fastq.gz"), emit: fq

    script:
    def bbduk_cmd = bbdukCommand(meta.samplename, meta.down_size, input_files, meta.is_paired)
    """
    echo "Debug: meta = ${meta}"
    echo "Debug: Input files = ${input_files}"

    ${bbduk_cmd}
    """
}

def bbdukCommand(samplename, down_size, input_files, is_paired) {
    if (is_paired) {
        return """
        bbduk.sh in1=${input_files[0]} in2=${input_files[1]} reads=$down_size \
        out1=${samplename}_R1_sub.fastq.gz out2=${samplename}_R2_sub.fastq.gz overwrite=t
        """
    } else {
        return """
        bbduk.sh in=${input_files[0]} reads=$down_size \
        out=${samplename}_sub.fastq.gz overwrite=t
        """
    }
}
