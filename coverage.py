#!/usr/bin/env python3

##################################
# Project: Maesa Phylogeny
# script: coverage.py
# --- Action: mask any bases with low coverage
# USAGE: use coverage_use.sh for execution
# Author: Wolf Eiserhardt
# Edited to be executable in different working directory path by Pirada Sumanon
# Last changed: 27/05/2021
##################################


import os, argparse, subprocess
from Bio import SeqIO
from Bio.Seq import Seq

parser = argparse.ArgumentParser()
parser.add_argument("sample")
args = parser.parse_args()
sample = str(args.sample)


#Directory variables
cwd = os.getcwd() #at this point, it will be in hybpiper directory
a = cwd.split("/")[:-1]
coverage_dir = "/".join(a)+"/coverage"
trimmed_dir = "/".join(a)+"/trimmed"

# depth required to KEEP (i.e. anything <trshld will be discarded)
trshld = 2

# Get all subdirectories in the current working directory. these are the loci recovered by hybpiper
loci = next(os.walk(sample))[1]

# sequences = []
sequences = {}

for locus in loci: 

        #exon
        #pth = sample+'/'+locus+'/'+sample+'/sequences/FNA/'+locus+'.FNA'       

        #supercontig
        pth = sample+'/'+locus+'/'+sample+'/sequences/intron/'+locus+'_supercontig.fasta'       
        
        if os.path.isfile(pth):
                for record in SeqIO.parse(pth, "fasta"):
                        record.id = record.id+'_'+locus
                        #sequences.append(record)
                        sequences[record.id] = record
                        
with open(coverage_dir+'/'+sample+'.fasta', "w") as outfile:
        SeqIO.write(list(sequences.values()), outfile, "fasta")

print(sample+'.fasta generated')

# BWA index targets
cmd = 'bwa index '+coverage_dir+'/'+sample+'.fasta'
subprocess.call(cmd,shell=True)
print(sample+'.fasta indexed')

# BWA mem paired reads

cmd = 'bwa mem '+coverage_dir+'/'+sample+'.fasta '+trimmed_dir+'/'+sample+'_1_paired_trimmed.fastq '+trimmed_dir+'/'+sample+'_2_paired_trimmed.fastq | samtools view -b -o '+coverage_dir+'/'+sample+'.bam'
subprocess.call(cmd,shell=True)
print('paired reads mapped to '+sample+'.fasta')

# BWA mem unpaired reads

cmd = 'bwa mem '+coverage_dir+'/'+sample+'.fasta '+trimmed_dir+'/'+sample+'_unpaired12.fastq | samtools view -b -o '+coverage_dir+'/'+sample+'_up.bam'
subprocess.call(cmd,shell=True)
print('unpaired reads mapped to '+sample+'.fasta')

# merge BAM files
cmd = 'samtools merge '+coverage_dir+'/'+sample+'_all.bam '+coverage_dir+'/'+sample+'.bam '+coverage_dir+'/'+sample+'_up.bam'
subprocess.call(cmd,shell=True)
print('BAMs merged')

# sort and index BAM files
cmd = 'samtools sort '+coverage_dir+'/'+sample+'_all.bam -o '+coverage_dir+'/'+sample+'_all_sorted.bam'
subprocess.call(cmd,shell=True)
cmd = 'samtools index '+coverage_dir+'/'+sample+'_all_sorted.bam'
subprocess.call(cmd,shell=True)
print('BAM indexed and sorted')

# remove duplicates
cmd = 'java -jar ~/picard.jar MarkDuplicates I='+coverage_dir+'/'+sample+'_all_sorted.bam O='+coverage_dir+'/'+sample+'_all_sorted_deduplicated.bam M='+coverage_dir+'/'+sample+'marked_dup_metrics.txt REMOVE_DUPLICATES=true'
subprocess.call(cmd,shell=True)
print('reads deduplicated for sample '+sample)

# calculate coverage
cmd = 'samtools depth '+coverage_dir+'/'+sample+'_all_sorted_deduplicated.bam > '+coverage_dir+'/'+sample+'.cov'
subprocess.call(cmd,shell=True)
print('coverage calculated for sample '+sample)

# define function to replace nth position of sequence with N
def n2N(sqnc, pstn):
        sqnc = list(sqnc)
        sqnc[int(pstn)-1] = "N"
        return "".join(sqnc)

# process coverage
with open(coverage_dir+'/'+sample+'.cov', "r") as covfile:
        for line in covfile:
                line = line.strip()
                LINE = line.split("\t")
                if int(LINE[2]) < trshld:
                        sequences[LINE[0]].seq = n2N(sequences[LINE[0]].seq,LINE[1])

# remove unnecessary leading and trailing Ns
for nm in sequences.keys():
        sequences[nm].seq = sequences[nm].seq.strip("N")
        if isinstance(sequences[nm].seq, str):
                sequences[nm].seq = Seq(sequences[nm].seq)

print('coverage trimming completed, keeping only positions with coverage of '+str(trshld)+' or above')

# write outfile
with open(coverage_dir+'/'+sample+'_trimmed.fasta', "w") as outfile:
        SeqIO.write(list(sequences.values()), outfile, "fasta")
print('trimmed seqs written to '+sample+'_trimmed.fasta')

# remove unnecessary files
#cmd = "find 'coverage_dir+' -type f ! -name '*.fasta' -delete"
#subprocess.call(cmd, shell=True)
#print('tidied up.')
