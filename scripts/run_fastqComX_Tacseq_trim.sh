#!/bin/bash
#$ -N run_fastqComX_Tacseq_trim
#$ -t 1-24
#$ -q jje,pub8i,abio,bio,free64,free24i
#$ -ckpt restart

module load enthought_python/7.3.2
# the program only works for python2.7.3.. 
# download from: https://github.com/enormandeau/Scripts/blob/master/fastqCombinePairedEnd.py

theline=`head -n $SGE_TASK_ID scripts/jay_Tacseq_trim.txt | tail -n 1`
in1=`echo $theline | cut -d" " -f1`
in2=`echo $theline | cut -d" " -f2`

python ~/software/fastqCombinePairedEnd.py raw/Tacseq_trim/$in1 raw/Tacseq_trim/$in2
