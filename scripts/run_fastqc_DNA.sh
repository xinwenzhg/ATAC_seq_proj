#!/bin/bash
#$ -N 'qc_of_dna'
#$ -q jje
#$ -t 1-24

module load fastqc
# run from the script directory: 
mkdir ../analysis/DNAseq_qc_output/
ls ../raw/DNA/*.gz  | xargs -n 1 basename > ./filename.txt
echo "$SGE_TASK_ID" >&2
myline=$SGE_TASK_ID
echo "$myline" >&2
seed=$(head -n $myline filename.txt | tail -n 1)
echo $seed
fastqc ../raw/DNA/$seed -o ../analysis/DNAseq_qc_output/
