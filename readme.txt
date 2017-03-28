ATACseq Project

The github repo only contains scripts, the output files are too big to upload. 
Output files can be found on HPC:
	/dfs1/bio/xinwenz/tndata/result/macs2m_Tacseq_tag_output_peak/*
	/dfs1/bio/xinwenz/tndata/result/macs2m_Tacseq_tag_output_bw/*
Midsteps files can be found 
	/dfs1/bio/xinwenz/tndata/midstep/* 

Softwares need but not on HPC (all install in ~/software)
	1.atac_dnase_pipelines
	    $ git clone https://github.com/kundajelab/atac_dnase_pipelines --recursive
	2.kentUtils (jje module not working)
	   $ git clone git://github.com/ENCODE-DCC/kentUtils.git
	3.fastqCombinePairedEnd.py
	   https://github.com/enormandeau/Scripts/blob/master/fastqCombinePairedEnd.py
	4.macs2
	   pip install --user macs2

## organize ATACseq files
	input:  
		scripts/namemap_Tacseq.txt
	output: 
		raw/Tacseq/*
	shell:
		mkdir raw
		mkdir raw/Tacseq		
		python scripts/organize_tacseq_files.py
	example: 
		A4_P004_2_R1.fq.gz
		A4_POO4_2_R2.fq.gz

## detect adapter
	input:  
		scripts/jay_Tacseq_lst_gt.py  # for job array
		raw/Tacseq/*
	output:
		scripts/jay_Tacseq_lst.txt  #
		midstep/detAdp_output.txt 
	shell:
		mkdir midstep
		python scripts/jay_Tacseq_lst_gt.py
		qsub scripts/run_detAdp_Tacseq.sh
	comments:
		All samples use Nextera adapter
	
## trim adapter
	input: 
		raw/Tacseq/*
	output: 
		raw/Tacseq_trim/*.trim.fq.gz
	shell:
		mkdir raw/Tacseq_trim
		qsub scripts/run_cutadapt_Tacseq.sh
	example:
		A7_P060_R1.trim.fq.gz
		A7_P060_R2.trim.fq.gz


## make trimed R1,R2 file same length
	input:
		scripts/jay_Tacseq_trim_gt.py
		raw/Tacseq_trim/*.trim.fq.gz
	output:
		raw/Tacseq_trim/*_pairs_R1.fastq.gz
		raw/Tacseq_trim/*_pairs_R2.fastq.gz
	shell:
		python scripts/jay_Tacseq_trim_gt.py
		qsub scripts/run_fastqComX_Tacseq_trim.sh

## Prepare referece genome and dm6 chromosome length file (will be used for bedgraph producing)
	input:
		ref/*.fa.gz
		ref/*.gtf
	output:
		ref/*.bt
		ref/*.chome.siz
	shell:
		qsub scripts/run_index_ref.sh
		~/software/kentUtils/bin/fetchChromSizes dm6 ref/dm6.chrome.siz

## bowtie align
	input:
		scripts/jay_Tacseq_trim.txt
		raw/Tacseq_trim/*._pairs_R{1,2}.fastq.gz
	output:
		midstep/bowtie2m_Tacseq_trim_output/*
	shell:
		mkdir midstep/bowtie2m_Tacseq_trim
		qsub scripts/run_bowtie2m_Tacseq_trim.sh
	example:
		A7_P060.sort.bam


## remove unmapped, multimapped reads;
## mark duplicates and remove them; fix mate;
## get flagstat, get duplication matrix; get library complexicity qc. 
## change filtered bam to bedpe files.
	input:
		midstep/bowtie2m_Tacseq_trim_output/*.sort.bam
	output:
		 midstep/atacPip_Tacseq_bam_output_flt/*.bam
		 midstep/atacPip_Tacseq_bam_output_qc/*
		 midstep/atacPip_Tacseq_bam_output_bedpe/*.bedpe
	shell:
		mkdir midstep/atacPip_Tacseq_bam_output....
		qsub scripts/run_atacPip_Tacseq_bam.sh
	example:
		 A7_P060.bedpe.gz
		 A7_P060_flt.nsort.bam	



## pool bedpe files together for each genotype_tissue,;
## transfer to tag file;
## TN5 shifting for each tag file 
## split each tag file into two pseudo-replicates
	input:
		midstep/atacPip_Tacseq_bam_output_bedpe
		sripts/jay_Tacseq_bedpe_gt.py
	output:
		midstep/gatTag_Tacseq_bedpe_output/*.tag.gz
	 	 midstep/gatTag_Tacseq_bedpe_output/*_PP1.tag.gz
 		 midstep/gatTag_Tacseq_bedpe_output/*_PP2.tag.gz
	shell:
		mkdir midstep/gatTag_Tacseq_bedpe_output
		python scripts/jay_Tacseq_bedpe_gt.py
		qsub scripts/run_gatTag_Tacseq_bedpe.sh



## narrow peak calling for all pooled tag files
## narrow peak calling for peudo replicate1,2
## bedgraph to bigwig for pooled files
## get naive overlap of peudo replicate 1 and 2.	
	input:
		midstep/getTag_Tacseq_bedpe_output/*
	output
		result/macs2m_Tacseq_tag_output_bw/*.bw
		result/macs2m_Tacseq_tag_output_peak/*.narrowPeak.gz
		result/macs2m_Tacseq_tag_output_peak/*_overlap.narrowPeak
