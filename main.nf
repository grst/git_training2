#!/usr/bin/env nextflow
params.out_dir = "results"
params.reads = "testdata/testdata/*.fastq.gz"
params.annotation_gtf = "testdata/reference/genes.gtf"
params.genome = "testdata/reference/genome.fa"

Channel.fromPath(params.reads).into { fastq_channel_1; fastq_channel_2}

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

process star {
    publishDir "${params.out_dir}/star"

    input:
       file in_fastq from fastq_channel_2
       file gtf from file(params.annotation_gtf)
       file genome from file(params.genome)

    output:
        file "*.bam" into bam_files

    script:
     """
        GZIP=""
        if [[ "${in_fastq}" == *".gz"* ]]; then
            GZIP="--readFilesCommand zcat"
        fi
        STAR --runThreadN ${task.cpus} --genomeDir star \$GZIP \
                --readFilesIn ${in_fastq} \
                --outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 16000000000 --outSAMunmapped Within \
                --twopassMode Basic --outFilterMultimapNmax 1 --quantMode TranscriptomeSAM \
                --outFileNamePrefix "${in_fastq.baseName}."
    """
}


