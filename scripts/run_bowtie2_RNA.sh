#! /bin/bash
#$ -N align
#$ -q jje,class8-intel,bio,abio
#$ -pe openmp 8-32
#$ -t 1-50
module load bowtie2
file='align_rnafile.txt'
fq1=`head -n $SGE_TASK_ID $file | tail -n 1 | cut -f1`
fq2=`head -n $SGE_TASK_ID $file | tail -n 1 | cut -f2`
output=`head -n $SGE_TASK_ID $file | tail -n 1 | cut -f3`
echo $fq1 1>&2
echo $fq2 1>&2
echo $output 1>&2
bowtie2 -p $NSLOTS -x ../ref/dmel_all -1 $fq1 -2 $fq2 -S $output
