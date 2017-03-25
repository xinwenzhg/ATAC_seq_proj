import os,re,glob
os.chdir('/dfs1/bio/xinwenz/tndata/raw/RNA/')
#os.makedirs('/dfs1/bio/xinwenz/tndata/analysis/rna_sam')
os.chdir('/dfs1/bio/xinwenz/tndata/raw/RNA/')
output_sam_dir = '/dfs1/bio/xinwenz/tndata/analysis/rna_sam/'
source_dir = '/dfs1/bio/xinwenz/tndata/raw/RNA/'
for i in range(1,51):
	inputfiles = glob.glob('*%03d*'%i)
	input1 = inputfiles[0]
	input2 = inputfiles[1]
	#print input1	
	smp = re.search(r'\w*_(\d{3})',input1).group(1)
	#print smp
	newfile = 'sample_'+smp+'.sam'
	#print newfile
	print '%s\t%s\t%s'%(source_dir+input1,source_dir+input2,output_sam_dir+newfile)	
