include { DOWNSAMPLING } from '../modules/downsampling'

workflow PREPROCESS {
    take:
    input_ch

    main:
    DOWNSAMPLING(input_ch)

    emit:
    fq = DOWNSAMPLING.out.fq
}