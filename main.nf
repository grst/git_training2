#!/usr/bin/env nextflow
params.out_dir = "results"
params.reads = "testdata/testdata/*.fastq.gz"
params.star_index = "/data/genomes/hg38/index/STAR/2.7.1a/ensembl/Homo_sapiens.GRCh38.dna.primary_assembly/200/"

Channel.fromPath(params.reads).into { fastq_channel_1; fastq_channel_2}
Channel.fromPath(params.star_index).into { star_index }

process fastqc {
    publishDir "${params.out_dir}/fastqc"

    input: 
       file fastq from fastq_channel_1

    output:
        file "*.html" into fastq_html

    script:
    """
    fastqc ${fastq}
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
    zcat ${in_fastq} | grep "^@" | wc -l > ${in_fastq.baseName}.txt
    """
}


