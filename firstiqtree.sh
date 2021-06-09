#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=firstiqtree
#SBATCH --time=07-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: firstiqtree.sh
# --- Action: run preliminary IQ-TREE
# --- Input: rogue-pruned exon-added alignments, partition files
# --- Output: gene trees
# USAGE: sbatch firstiqtree.sh (execute in GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 08/06/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts
WD=$PWD/steps #current working directory

#make new directories
mkdir -p $WD/prelim_iqtree

#######################
#---EXECUTE SCRIPTS---#
#######################
cd $WD/prelim_iqtree

#copy files to the 'prelim_iqtree'
cp $WD/RNR/roguepruned_alignments/*_prunedexonadded.fasta .
cp $WD/iqtree_prepare/*_part.txt .

#create done and genetrees directories
mkdir done genetrees

for f in *_prunedexonadded.fasta
do 
        iqtree -s $f -m MFP -T AUTO -p ${f/_prunedexonadded.fasta}_OGexonadded_aligned_part.txt -B 1000
        mv ${f/_prunedexonadded.fasta}_OGexonadded_aligned_part.txt.treefile genetrees/${f/_prunedexonadded.fasta}_OGexonadded_aligned_part.txt.tre
        mv ${f/_prunedexonadded.fasta}_OGexonadded_aligned_part.txt* genetrees
        mv $f done
done
