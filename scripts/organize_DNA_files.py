# python2, symlink copy and rename
import fileinput
import os
import glob
import re
wkdir = '/dfs1/bio/xinwenz/'
source_dir = wkdir + 'Bioinformatics_Course/DNAseq/'
dest_dir = wkdir + 'tndata/raw/DNA/'
mapfile = source_dir + 'namemap.txt'

with open(mapfile) as mf:
	for line in mf:
		tmp = line.split()
		newp = tmp[0]
		oldp = tmp[2]
		print oldp,newp
		for filename in glob.glob('%s*.fq.gz' %(source_dir + oldp)):
			newname = re.sub(r'^.*ADL[^\_]*','%s'%(dest_dir+newp),filename)
			
			print filename			
			print newname
			os.symlink(filename,newname)
