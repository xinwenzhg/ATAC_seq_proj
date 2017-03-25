import os,re,glob
source_dir = '/dfs1/bio/xinwenz/Bioinformatics_Course/ATACseq/'
dest_dir = '/dfs1/bio/xinwenz/tndata/raw/Tacseq/' 
os.chdir(source_dir)
mp = open('namemap.txt')
for line in mp:	
	tmp = line.split()
	lab = tmp[0]
	geno = tmp[1]
	rep = tmp[3]
	print lab
	for filename in glob.glob('*%s*'%lab):
		print filename
		read = re.search(r'(R[12])',filename).group(1)
		newname = geno+'_'+lab+'_'+rep+'_'+read+'.fq.gz'
		print newname
		os.symlink(source_dir+filename,dest_dir+newname)
mp.close()
