import os,re
fnms = os.listdir('../raw/DNA')
for oldname in fnms: 
	newname = oldname[0:6] + '.new.fq.gz'
	print '%s\t%s'%(oldname,newname)
