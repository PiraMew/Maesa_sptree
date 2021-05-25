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
# USAGE: sbatch coverage_use.sh (*execute from global working directory, `/faststorage/project/Maesa`, in my case)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

#####################
#----DIRECTORIES----#
#####################

#working directories
GWD=$PWD #global working directory, with subprojects and scripts (`/faststorage/project/Maesa`, in my case)
WD=$GWD/steps/hybpiper #current working directory

#make a new directory for outputs
mkdir -p $WD/coverage


#########################
#----EXECUTE SCRIPTS----#
#########################

cd $WD
while read name; do $GWD/scripts/coverage.py $name; done < namelist.txt
