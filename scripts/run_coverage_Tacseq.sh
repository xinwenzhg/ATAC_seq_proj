#!/bin/bash
#$ -N run_coverage
#$ -q jje,abio,bio,pub8i,free88i,free72i,free40i
#$ -t 1-24

module load samtools/1.3
module load bedtools/2.25.0

in1=`head -n $SGE_TASK_ID jay_Tacseq.txt | tail -n 1 | cut -f3`
input1="../analysis/bowtie2_Tacseq_output/$in1"

out1=`head -n $SGE_TASK_ID jay_Tacseq.txt | tail -n 1 | cut -f4`
output1="../analysis/coverage_Tacseq_output/$out1"

out2=`head -n $SGE_TASK_ID jay_Tacseq.txt | tail -n 1 | cut -f5`
output2="../analysis/kent_Tacseq_output/$out2"

samtools index $input1

Nreads=`samtools view -c -F 4 $input`
Scale=`echo "1.0/($Nreads/1000000)" | bc -l`

genomeCoverageBed -ibam $input -bg -scale $Scale > $output
kentUtils/bin/linux.x86_64/bedGraphToBigWig sample_1.coverage $ref.fai sample_1.bw
~/software/kentUtils/bin/bedGraphToBigWig $output1 ../ref/dmel_all_613.fa.fai $output2 




