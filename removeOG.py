#!/usr/bin/env python3

# this script removes outgroup sequences from the alignments
# input: alignments, outgroups.txt
# Author: Pirada Sumanon
# Date: 01/06/2021

import os
from Bio import SeqIO

#Directory variables
cwd = os.getcwd() #at this point, it will be in alignments_edited/noempty directory
a = cwd.split("/")[:-2]
essential_dir = "/".join(a)+"/essential"


with open(essential_dir+"/outgroups.txt", "r") as f:
    outgroup = [line.strip() for line in f]
    
for alignment in os.listdir():
    keep = []
    for record in SeqIO.parse(alignment, "fasta"):
        if record.id not in outgroup:
            keep.append(">" + str(record.id) + "\n")
            keep.append(str(record.seq) + "\n")
           
    newFile = str(alignment.split(".")[0]) + "_noOG.fasta"
    with open(newFile,"w") as f:
        for line in keep:
            f.write(line)
