#!/bin/bash
#$ -N run_bowtie2m_Tacseq_trim
#$ -q jje,abio,bio,free64,free48,free88i,free32i,free72i,free40i
#$ -t 1-24
#$ -R y
#$ -pe openmp 8-24
#$ -ckpt restart

module load bowtie2/2.2.7
module load samtools/1.3

theline=`head -n $SGE_TASK_ID scripts/jay_Tacseq_trim.txt | tail -n 1`
in1=`echo $theline | cut -d" " -f1`
in2=`echo $theline | cut -d" " -f2`
out1=`echo $theline | cut -d" " -f3`

tmpid="tmp_$SGE_TASK_ID"
bowtie2 -k 4 -X2000 --mm --threads $NSLOTS -x ref/dmel6_ucsc  -1 raw/Tacseq_trim/"$in1"_pairs_R1.fastq.gz -2 raw/Tacseq_trim/"$in2"_pairs_R2.fastq.gz | samtools view -bS | samtools sort -T $tmpid  -o midstep/bowtie2m_Tacseq_trim_output/$out1

