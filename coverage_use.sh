#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=coverage
#SBATCH --time=07-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: coverage_usage.sh
# --- Action: execute coverage.py
# --- Input: HybPiper outputs, namelist.txt
# --- Output: trimmed sample-level fasta
# USAGE: sbatch coverage_use.sh (*execute from within hybpiper directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

#####################
#----DIRECTORIES----#
#####################

#working directories
GWD=$PWD #global working directory, with subprojects and scripts
WD="$GWD"/ #current working directory


#########################
#----EXECUTE SCRIPTS----#
#########################

cd 
while read name; do /faststorage/project/Maesa/scripts/coverage.py $name; done < namelist.txt
