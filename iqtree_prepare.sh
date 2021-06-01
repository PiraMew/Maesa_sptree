#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=prepareIQtree
#SBATCH --time=00-06:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=4

##################################
# Project: Maesa Phylogeny
# script: iqtree_prepare.sh
# --- Action: prepare files for IQ-Tree
# --- Input: manual edited alignments
# --- Output: clean alignments and partition files
# USAGE: sbatch iqtree_prepare.sh
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 01/06/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts
WD=$PWD/steps/alignments_edited #current working directory

cd $WD

#######################
#---EXECUTE SCRIPTS---#
#######################

#remove empty sequence(s) from the alignment
for f in *.aln; do ($GWD/scripts/remove_empty.py $f); done

#generate partition files and remove exon sequences
$GWD/scripts/partitioner_v2.py --smoother 10
