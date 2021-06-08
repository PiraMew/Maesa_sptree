#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=MLtrees
#SBATCH --time=07-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: 10MLtrees.sh
# --- Action: produce 10 ML trees using IQtree for rogues detection
# --- Input: cleaned alignments
# --- Output: 10 Maximum Likelihood trees
# USAGE: sbatch 10MLtrees.sh (execute in iqtree_prepare directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 01/06/2021
##################################

#run iqtree for 10MLtrees
for f in *_clean.fasta
do 
        iqtree -s $f --runs 10
done

#move output to subdirectory
mkdir 10MLtrees_done
mv *_clean.fasta.* 10MLtrees_done
