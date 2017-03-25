import os,re
fnms =  os.listdir('raw/DNAn')
fnms.sort()
file_num = len(fnms)
for i in [x*2 for x in range(file_num/2)]:
	in1 = fnms[i]
	in2 = fnms[i+1]
	out = fnms[i][0:4] + '.sort.bam'
	print "%s\t%s\t%s"%(in1,in2,out)

