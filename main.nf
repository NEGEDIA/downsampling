#!/usr/bin/env nextflow

// Funzione per controllare il numero di elementi in una riga
def checkNumberOfItem(row, number) {
    return row.size() == number
}

// Lettura del file TSV, parsing e configurazione dei dati
if (params.input) {
    def fileCsv = file(params.input)
    Channel
        .from(fileCsv)
        .splitCsv(sep: ',', header: true) // Assume che ci sia un header
        .map { row ->
            // Estrai i campi dalla riga TSV
            def samplename = row[1]
            def down_size = row[2]
            def input_path = row[0] // Assumi che 'returnFile' gestisca il path
            def output_path = row[3]
            
            // Controlla se ci sono 4 colonne
            if (!checkNumberOfItem(row, 4)) {
                throw new IllegalArgumentException("Il file CSV deve contenere esattamente 4 colonne!")
            }

            return [samplename, down_size, input_path, output_path]
        }
        .set { input_ch } // Imposta il canale di input
}


/*
input_ch = Channel.fromPath( params.input )
                    .splitCsv( header: true)
                    .map { row -> tuple(samplename = row.sample_name, down_size = row.down_size, input = row.input_path, output = row.output_path) }
*/
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
