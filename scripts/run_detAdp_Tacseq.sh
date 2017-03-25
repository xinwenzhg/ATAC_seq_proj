#!/bin/bash
#$ -N run_detAdp_Tacseq
#$ -q pub8i,jje,bio,abio
#$ -ckpt blcr

module load anaconda/3.5-2.4.0 # python3 works, the default python2 does not work. 
touch midstep/detAdp_output.txt
for fls in raw/Tacseq/*
do
python3 ~/software/atac_dnase_pipelines/utils/detect_adapter.py $fls | head -n 9 | tail -n 1 | cut -f3 >> midstep/detAdp_output.txt
done
