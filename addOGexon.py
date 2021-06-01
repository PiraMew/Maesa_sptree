#!/usr/bin/env python3

# this script adds outgroup exons to the alignments
# input: alignments with no outgroups, outgroups.txt
# Author: Pirada Sumanon
# Date: 01/06/2021

import os
from Bio import SeqIO

#Directory variables
cwd = os.getcwd() #at this point, it will be in alignments_edited/noempty directory
a = cwd.split("/")[:-1]
essential_dir = "/".join(a)+"/essential"
hybpiper_dir = "/".join(a)+"/hybpiper"


with open(essential_dir+"/outgroups.txt", "r") as f:
    outgroup = [line.strip() for line in f]


for fn in os.listdir(): #list file in current directory
    locus = fn.split("_")[0] #split file name and select the first as locus
    og_exon = []
    for sp in outgroup:
        if os.path.isfile(hybpiper_dir+"/"+sp+"/"+locus+"/"+sp+"/sequences/FNA/"+locus+".FNA") == True:
            OG = list(SeqIO.parse(hybpiper_dir+"/"+sp+"/"+locus+"/"+sp+"/sequences/FNA/"+locus+".FNA", "fasta"))[0]
            og_exon.append(">" + str(OG.id) + "\n")
            og_exon.append(str(OG.seq) + "\n")
    
    newFile = str(fn.split("_")[0]) + "_OGexon.fasta"
    with open(newFile,"w") as f:
        for line in og_exon:
            f.write(line)
