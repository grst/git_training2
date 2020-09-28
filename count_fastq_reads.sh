##########################################################
# USAGE:
# 	count_fastq_reads.sh FASTQ_FILE
# 
# Counts how many reads are in a FASTQ file. 
##########################################################

FASTQ_FILE=$1

if [[ $FASTQ_FILE =~ \.gz$ ]]; then
    COMMAND=zcat
else
    COMMAND=cat
fi

$COMMAND "$FASTQ_FILE" | grep  "^@" | wc -l 
