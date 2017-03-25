#!/bin/bash
#$ -N run_gatTag_Tacseq_bedpe
#$ -q jje,abio,bio,pub8i
#$ -ckpt restart
#$ -t 1-8 

sun=$SGE_TASK_ID
theline=`head -n $sun scripts/jay_Tacseq_bedpe.txt | tail -n 1`
in1=`echo $theline | cut -d" " -f1`
in2=`echo $theline | cut -d" " -f2`
in3=`echo $theline | cut -d" " -f3`

out1=`echo $theline | cut -d" " -f4`
out_tmp=`basename $out1 .tag.gz`
out2="$out_tmp"_PP1.tag.gz
out3="$out_tmp"_PP2.tag.gz

infd="midstep/atacPip_Tacseq_bam_output_bedpe"
outfd="midstep/gatTag_Tacseq_bedpe_output"

# change bedpe to tag file, also do TN5 shifting
zcat $infd/$in1 $infd/$in2 $infd/$in3 | awk 'BEGIN{OFS="\t"}{printf "%s\t%s\t%s\tN\t1000\t%s\n%s\t%s\t%s\tN\t1000\t%s\n",$1,$2,$3,$9,$4,$5,$6,$10}' | awk -F $'\t' 'BEGIN {OFS = FS}{ if ($6 == "+") {$2 = $2 + 4} else if ($6 == "-") {$3 = $3 - 5} print $0}' |gzip -c > $outfd/$out1

# split the gather tag into peudo replicate 1 and peudo replicat 2 
tlines=`zcat $outfd/$out1 | wc -l`
nlines=`echo "($tlines+1)/2" | bc`
zcat $outfd/$out1 | shuf | split -d -l $nlines - $sun
gzip "$sun"00
gzip "$sun"01
mv "$sun"00.gz $outfd/$out2
mv "$sun"01.gz $outfd/$out3  




