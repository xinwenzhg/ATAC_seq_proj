#!/bin/bash
#$ -N run_atacPip_Tacseq_bam
#$ -q jje,abio,bio,free64,pub8i
#$ -t 1-24
#$ -ckpt restart

module load java/1.7
module load bedtools/2.25.0
module load samtools/1.3

theline=`head -n $SGE_TASK_ID scripts/jay_Tacseq_trim.txt| tail -n 1`
in1=`echo $theline | cut -d" " -f3`
smpName=`basename $in1 .sort.bam`

smp=$SGE_TASK_ID

# filter unmapped, fixmate
samtools view -F 524 -f2 -u midstep/bowtie2m_Tacseq_trim_output/$in1 | samtools sort -n -T tmp1_$SGE_TASK_ID |samtools view -h |  python ~/software/atac_dnase_pipelines/utils/assign_multimappers.py -k 4 --paired-end | samtools view -bS | samtools fixmate -r - - | samtools view -F 1804 -f 2 -u | samtools sort -T tmp2_$SGE_TASK_ID  > temp_$SGE_TASK_ID.sort.bam


# mark duplicates, needs a coordinate sorted bam 
java -Xmx1G -jar /data/apps/picard-tools/1.11/MarkDuplicates.jar INPUT=temp_$smp.sort.bam OUTPUT=temp_$smp.dup.bam  METRICS_FILE=midstep/atacPip_Tacseq_bam_output_qc/"$smpName".dup.qc  VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true REMOVE_DUPLICATES=false

#remove duplicates:
samtools view -F 1804 temp_$smp.dup.bam -bS | samtools sort -n -T tmp3_$smp > midstep/atacPip_Tacseq_bam_output_flt/"$smpName"_flt.nsort.bam
#samtools index midstep/atacPip_Tacseq_bam_output_flt/$smpName.flt.sort.bam
samtools flagstat midstep/atacPip_Tacseq_bam_output_flt/"$smpName"_flt.nsort.bam > midstep/atacPip_Tacseq_bam_output_qc/$smpName.flagstat

rm temp_$smp.sort.bam
rm temp_$smp.dup.bam

# compute library complexity:
# check the librry bottle neck

bedtools bamtobed -bedpe -i midstep/atacPip_Tacseq_bam_output_flt/"$smpName"_flt.nsort.bam | awk 'BEGIN{OFS="\t"}{print $1,$2,$4,$6,$9,$10}' | grep -v 'chrM' | sort | uniq -c | awk 'BEGIN{mt=0.000001;m0=0.000001;m1=0;m2=0.0001} ($1==1){m1=m1+1} ($1==2){m2=m2+1} {m0=m0+1} {mt=mt+$1} END{printf "%d\t%d\t%d\t%d\t%f\t%f\t%f\n",mt,m0,m1,m2,m0/mt,m1/m0,m1/m2}' > midstep/atacPip_Tacseq_bam_output_qc/$smpName.pbc.qc

# change to bedpe file

bedtools bamtobed -bedpe -mate1 -i midstep/atacPip_Tacseq_bam_output_flt/"$smpName"_flt.nsort.bam | gzip -c > midstep/atacPip_Tacseq_bam_output_bedpe/"$smpName".bedpe.gz

