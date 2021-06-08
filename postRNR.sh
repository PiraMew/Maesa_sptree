#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=postRNR
#SBATCH --time=00-06:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=4

##################################
# Project: Maesa Phylogeny
# script: poostRNR.sh
# --- Action: remove and add outgroup exons back to the alignments
# --- Input: rogue-pruned alignments, OGexons from previous steps (in `addOGexons`)
# --- Output: pruned OGexon-added alignments
# USAGE: sbatch postRNR.sh (execute in GWD)
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
mkdir -p $WD/RNR/roguepruned_alignments

#######################
#---EXECUTE SCRIPTS---#
#######################
cd $WD
#copy pruned sequences from RNR to new directory
cp $WD/RNR/*_pruned.fasta $WD/RNR/roguepruned_alignments

#remove outgroup sequences
cd $WD/RNR/roguepruned_alignments
python $GWD/scripts/removeOG.py

for f in *_noOG.fasta;
do (mafft --keeplength --add $WD/addOGexons/${f/_pruned_noOG.fasta}_OGexon.fasta --auto $f > ${f/_noOG.fasta}exonadded.fasta);
done
