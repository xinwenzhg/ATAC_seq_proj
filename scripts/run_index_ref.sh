#!/bin/bash
#$ -N run_index_ref
#$ -q jje,class8-intel,bio,abio,pub64,free64
#$ -t 1-3

module load bowtie2/2.2.7
module load samtools/1.3
module load java/1.7

wkdir="ref/"
refname="dmel6_ucsc.fa"
refbase="dmel6_ucsc"

case $SGE_TASK_ID in
	"1") bowtie2-build  $wkdir$refname $wkdir$refbase;;
	"2") samtools faidx $wkdir$refname;;
	"3") java -d64 -Xmx1g -jar /data/apps/picard-tools/1.87/CreateSequenceDictionary.jar R=$wkdir$refname O=$wkdir$refbase.dict;;
esac
