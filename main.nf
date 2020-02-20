#!/usr/bin/env nextflow
params.out_dir = "results"
params.reads = "testdata/testdata/*.fastq.gz"

Channel.fromPath(params.reads).into { fastq_channel_1; fastq_channel_2}

process fastqc {
    publishDir "${params.out_dir}/fastqc"

    input: 
       file fastq from fastq_channel_1

    output:
        file "*.html" into fastq_html

    script:
    """
    fastqc ${fast}
    """
}

process count_reads {
    publishDir "${params.out_dir}/read_count"

    input:
       file in_fastq from fastq_channel_2

    output:
        file "*.txt" into bam_files

    script:
    """
    cat ${in_fastq} | grep "^@" | wc -l > ${in_fastq.baseName}.txt
    """
}


