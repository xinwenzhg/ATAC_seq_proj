#!/bin/bash
#$ -N run_seqtk
#$ -q jje 
#$ -t 1-24 

inputfile=`head -n $SGE_TASK_ID jobarray_seqtk.txt | tail -n 1 | cut -f1` 
outputfile=`head -n $SGE_TASK_ID jobarray_seqtk.txt | tail -n 1 | cut -f2`

~/software/seqtk/seqtk seq -Q64 -V ../raw/DNA/$inputfile | gzip -c > ../raw/DNAn/$outputfile
