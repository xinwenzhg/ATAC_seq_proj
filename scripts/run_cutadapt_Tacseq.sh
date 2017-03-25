#!/bin/bash
#$ -N run_cutadapt_Tacseq
#$ -q jje,pub8i,abio,bio,free88i,free24i
#$ -t 1-48
#$ -ckpt restart

theline=`head -n $SGE_TASK_ID scripts/jay_Tacseq_lst.txt | tail -n 1`
# after take the line, the tab change into a space!!! dont make same mistakes again
in1=`echo $theline | cut -d" " -f1`
out1=`echo $theline | cut -d" " -f2`
adapter=`head -n 1 midstep/detAdp_output.txt`

cutadapt -m 5 -e 0.2 -a $adapter raw/Tacseq/$in1 | gzip -c > raw/Tacseq_trim/$out1
