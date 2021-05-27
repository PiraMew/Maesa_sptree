#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=MAFFT
#SBATCH --time=00-08:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: MAFFT.sh
# --- Action: align sequences using MAFFT
# --- Input: *.FNA in seq_set2
# --- Output: alignment of each genes
# USAGE: sbatch MAFFT.sh (execute from GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 25/05/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts (in my case, it's /faststorage/project/Maesa)
WD=$PWD/steps #current working directory

#make new directories
mkdir -p $WD/MAFFT

##Working Directory: /faststorage/project/Maesa/steps/MAFFT
cd $WD/MAFFT
##first, copy data from seq_sets2 to the working directory
cp $WD/seq_sets2/*.FNA .


##ALIGNMENT

for f in *.FNA; do (echo ${f/.FNA} >> ./genenames.txt); done

mkdir ./alignedseq

parallel --eta "mafft --localpair --adjustdirectionaccurately --maxiterate 1000 {}.FNA > ./alignedseq/{}_aligned.fasta" :::: genenames.txt