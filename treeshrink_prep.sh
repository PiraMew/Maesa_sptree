#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=prep_treeshrink
#SBATCH --time=00-08:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: treeshrink_prep.sh
# --- Action: prepare a folder structure suitable for TreeShrink
# --- Input: gene trees in prelime_iqtree
# --- Output: files in a folder for TreeShrink
# USAGE: sbatch treeshrink_prep.sh (execute in GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 09/06/2021
##################################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts (in my case, it's /faststorage/project/Maesa)
WD=$PWD/steps #current working directory

#make new directory
mkdir -p $WD/treeshrink

#prepare folder
cd $WD/prelim_iqtree/genetrees

for f in *.tre
do
        g=${f#reduced_}
        mkdir $WD/treeshrink/${g/_OGexonadded_aligned_part.txt.tre}
        cp $f $WD/treeshrink/${g/_OGexonadded_aligned_part.txt.tre}/input.tre
done
