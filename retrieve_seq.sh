#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=retrieveseq
#SBATCH --time=00-05:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: retrieve_seq.sh
# --- Action: retrieve exons, introns and supercontigs using retrivec_sequences.py
# --- Input: HybPiper outputs
# --- Output: assembled supercontigs, exons, and introns
# USAGE: sbatch retrieve_seq.sh
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

##EXONS
python ~/HybPiper/retrieve_sequences.py ~/target/mega353.fasta . dna

##move exons to their own directory
mkdir contigs_exon
mv *.FNA ./contigs_exon

##INTRONS
##retrieving splash zone
##use intronerate_dev.py instead of intronerate.py which is a fixed version of some bugs.
##intronerate_dev.py hasn't been in the HybPiper release version yet
while read name;
do python ~/HybPiper/intronerate_dev.py --prefix $name;
done < namelist.txt

##Retrieving INTRONS
python ~/HybPiper/retrieve_sequences.py ~/target/mega353.fasta . intron

##move introns to their own directory
mkdir ./contigs_intron
mv *_introns.fasta ./contigs_intron

##SUPERCONTIGS
python ~/HybPiper/retrieve_sequences.py ~/target/mega353.fasta . supercontig

##move to their own directory
mkdir ./supercontigs
mv *_supercontig.fasta ./supercontigs
