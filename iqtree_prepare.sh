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

#make new directories
mkdir -p $WD/noempty
mkdir -p $PWD/steps/addOGexons
mkdir -p $PWD/steps/iqtree_prepare

#######################
#---EXECUTE SCRIPTS---#
#######################
cd $WD
#remove empty sequence(s) from the alignment
for f in *.aln; do (python $GWD/scripts/remove_empty.py $f); done
mv *_noempty.fasta $WD/noempty

#remove outgroup sequences and add outgroup exons to the alignments
cd $WD/noempty
python $GWD/scripts/removeOG.py
cp *_noOG.fasta $PWD/steps/addOGexons

cd $PWD/steps/addOGexons
python $GWD/scripts/addOGexon.py

for f in *_OGexon.fasta;
do (mafft --keeplength --add $f --auto ${f/_OGexon.fasta}_aligned_trimmed_noempty_noOG.fasta > ${f/.fasta}added_aligned.fasta);
done

cp *_OGexonadded_aligned.fasta $PWD/steps/iqtree_prepare

#generate partition files and remove exon sequences
cd $PWD/steps/iqtree_prepare
$GWD/scripts/partitioner_v2.py --smoother 10
