import glob, re, os


wkdir = '/dfs1/bio/xinwenz/tndata/raw/RNA'
os.chdir(wkdir)
for filename in os.listdir(wkdir):
	oldname = re.search(r'(\d*).*(R[12])', filename)
	sNum = int(oldname.group(1))
	Read =  oldname.group(2)
	newname = 'sample_' + '%03d'%sNum + '_%s'%Read + '.fastq.gz'
	#newname,filename
	os.rename(filename,newname)

