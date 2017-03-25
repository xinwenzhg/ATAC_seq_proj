import os
fnms = os.listdir('raw/Tacseq_trim')
fnms.sort()
file_num = len(fnms)
for i in [ x*2 for x in range(file_num/2) ]:
	in1 = fnms[i]
	in2 = fnms[i+1]
	out1 = fnms[i][0:7] + '.sort.bam'
	#out2 = fnms[i][0:7] + '.coverage'
	#out3 = fnms[i][0:7] + '.bw'
	#print "%s\t%s\t%s\t%s\t%s" %(in1,in2,out1,out2,out3)
	print "%s\t%s\t%s" %(in1,in2,out1) 
