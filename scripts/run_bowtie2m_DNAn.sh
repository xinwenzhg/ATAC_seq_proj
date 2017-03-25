#!/bin/bash
#$ -N run_bowtie2m_DNAn
#$ -q jje,abio,bio,pub64,free64,free48,free88i
#$ -R y
#$ -t 1-12
#$ -pe openmp 8-24
#$ -ckpt blcr

if [ "$SGE_TASK_ID" -eq "10" ]
then 
module load bowtie2/2.2.7
module load samtools/1.3

theline=`head -n $SGE_TASK_ID scripts/jay_DNAn.txt | tail -n 1`
in1=`echo $theline | cut -d" " -f1`
in2=`echo $theline | cut -d" " -f2`
out=`echo $theline | cut -d" " -f3`

tmpid="tmp_$SGE_TASK_ID"
bowtie2 -k 4 -X2000 --mm --threads $NSLOTS -x ref/dmel6_ucsc -1 raw/DNAn/$in1 -2 raw/DNAn/$in2 | samtools view -bS | samtools sort -T $tmpid -o midstep/bowtie2m_DNAn_output/$out 
fi
