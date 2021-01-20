#!/usr/bin/python
RESIDUES=[16, 20, 23, 27, 63, 67]
count=1
for res_ix1 in range(len(RESIDUES)):
  for res_ix2 in range(res_ix1,len(RESIDUES)):
    infile = open("in/"+`count`,'w')
    infile.write("residue1="+`RESIDUES[res_ix1]`+"\n"+"residue2="+`RESIDUES[res_ix2]`+"\n")
    infile.close()
    count += 1

