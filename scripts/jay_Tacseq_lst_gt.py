import os
nms = os.listdir('./raw/Tacseq')
for nm in nms:
	in1 = nm
	out1 = nm[0:7] + "_" + nm[10:12] + '.trim.fq.gz'	
	print "%s\t%s" %(in1,out1)
