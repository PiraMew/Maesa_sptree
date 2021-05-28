#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=optrimal_prepare
#SBATCH --time=00-03:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=4

##################################
# Project: Maesa Phylogeny
# script: optrimal_prepare.sh
# --- Action: prepare alignments for optrimAL
# --- Input: alignments
# --- Output: alignments with n-replacing
# USAGE: sbatch optrimal_prepare.sh
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 27/05/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts
WD=$PWD/steps #current working directory

#make new directories
mkdir -p $WD/optrimal_prepare
mkdir -p $WD/optrimal_ready

#copy alignments to new directory
cp $WD/MAFFT/alignments_exon/*.fasta $WD/optrimal_prepare

#replace n's with gaps (-) in alignments
cd $WD/optrimal_prepare
for f in *.fasta; do (python $WD/scripts/replace_n.py); done
