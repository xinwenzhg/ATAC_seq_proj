#!/bin/bash
#$ -N run_macs2m_Tacseq_tag
#$ -q jje,abio,bio,pub8i,free64,free88i
#$ -ckpt restart
#$ -t 1-8

module load enthought_python/7.3.2
module load bedtools

sun=$SGE_TASK_ID

in1=`head -n $sun scripts/jay_Tacseq_bedpe.txt | tail -n 1 | cut -f4`
nm=`basename $in1 .tag.gz`
in2="$nm"_PP1.tag.gz
in3="$nm"_PP2.tag.gz 

infld="midstep/gatTag_Tacseq_bedpe_output"
outfld1="result/macs2m_Tacseq_tag_output_bw"
outfld2="result/macs2m_Tacseq_tag_output_peak"


# call narrow peak from tag data and get final bigwig graph
macs2 callpeak -t $infld/$in1  -f BED -g dm -n $nm -p 0.01 --nomodel -B --SPMR --keep-dup all

macs2 bdgcmp -t "$nm"_treat_pileup.bdg -c "$nm"_control_lambda.bdg --o-prefix $nm -m FE

sort -k1,1 -k2,2n "$nm"_FE.bdg > "$nm"_FE.sort.bdg

bedtools slop -i "$nm"_FE.sort.bdg -g ref/dm6.chrome.siz -b 0 | ~/software/kentUtils/bin/bedClip stdin  ref/dm6.chrome.siz "$nm"_modify.bdg

~/software/kentUtils/bin/bedGraphToBigWig "$nm"_modify.bdg ref/dm6.chrome.siz $outfld1/"$nm".bw


sort -k 8gr,8gr "$nm"_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | gzip -c > $outfld2/"$nm".narrowPeak.gz

rm "$nm"_peaks.narrowPeak
rm "$nm"_control*
rm "$nm"_peaks*
rm "$nm"_treat*
rm "$nm"_summit*
rm "$nm"_FE*
rm "$nm"_modify*


# call narow peak in two peudoreplicates: 
macs2 callpeak -t $infld/$in2 -f BED -g dm -n "$nm"_PP1 -p 0.01 --nomodel -B --SPMR --keep-dup all
macs2 callpeak -t $infld/$in3 -f BED -g dm -n "$nm"_PP2 -p 0.01 --nomodel -B --SPMR --keep-dup all
# naive overlap

sort -k 8gr,8gr "$nm"_PP1_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | gzip -c > $outfld2/"$nm"_PP1.narrowPeak.gz

sort -k 8gr,8gr "$nm"_PP2_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | gzip -c > $outfld2/"$nm"_PP2.narrowPeak.gz


bedtools intersect -wo -a $outfld2/"$nm"_PP1.narrowPeak.gz -b $outfld2/"$nm"_PP2.narrowPeak.gz | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | cut -f 1-10 | sort | uniq >$outfld2/"$nm"_overlap.narrowPeak


rm "$nm"_PP{1,2}_peaks.narrowPeak
rm "$nm"_PP{1,2}_control*
rm "$nm"_PP{1,2}_peaks*
rm "$nm"_PP{1,2}_treat*
rm "$nm"_PP{1,2}_summit*
 

