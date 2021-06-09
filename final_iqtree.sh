#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=final_iqtree
#SBATCH --time=07-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: final_iqtree.sh
# --- Action: run final IQ-TREE
# --- Input: 2nd edited alignments, blacklists.txt, partition files
# --- Output: gene trees
# USAGE: sbatch final_iqtree.sh (execute in GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 09/06/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts
WD=$PWD/steps #current working directory

#make new directories
mkdir -p $WD/finaltree


###################
#---PREPARATION---#
###################

#blacklisting in alignments_edited_2nd
cd $WD/alignments_edited_2nd

#create an array for samples to be blacklisted
mapfile -t blacklists < $WD/essential/blacklists.txt

AMAS.py remove -x $blacklists -d dna -f fasta -i *.fasta -u fasta -g red_

#from output name 'red_*.fasta-out.fas', want to rename them to '*_prunedexonadded_reduced.fasta'
prefix="red_"
suffix=".fasta-out.fas"

for f in red_*.fasta-out.fas;
do
	foo=${f#"$prefix"}
	foo=${foo%"$suffix"}
	mv $f ${foo}_reduced.fasta
done

#copy input files for IQ-tree to the 'finaltree' directory
cp *_reduced.fasta $WD/finaltree
cp $WD/iqtree_prepare/*_part.txt $WD/finaltree


###################
#-----IQ-TREE-----#
###################

cd $WD/finaltree
mkdir done genetrees

for f in *_reduced.fasta
do 
        iqtree -s $f -m MFP -T AUTO -p ${f/_prunedexonadded_reduced.fasta}_OGexonadded_aligned_part.txt -B 1000
        mv ${f/_prunedexonadded_reduced.fasta}_OGexonadded_aligned_part.txt.treefile genetrees/${f/_prunedexonadded_reduced.fasta}_OGexonadded_aligned_part.txt.tre
        mv ${f/_prunedexonadded_reduced.fasta}_OGexonadded_aligned_part.txt* genetrees
        mv $f done
done



 

