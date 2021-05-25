#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=coverage
#SBATCH --time=07-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: coverage_usage.sh
# --- Action: execute coverage.py and samples2genes.py
# --- Input: HybPiper outputs, namelist.txt
# --- Output: trimmed fasta
# USAGE: sbatch coverage_use.sh (*execute from global working directory, `/faststorage/project/Maesa`, in my case)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

#####################
#----DIRECTORIES----#
#####################

#working directories
GWD=$PWD #global working directory, with subprojects and scripts (`/faststorage/project/Maesa`, in my case)
WD=$GWD/steps #current working directory

#make a new directory for outputs
mkdir -p $WD/coverage
mkdir -p $WD/seq_sets2


#########################
#----EXECUTE SCRIPT1----#
#########################

cd $WD/hybpiper
while read name; do $GWD/scripts/coverage.py $name; done < namelist.txt

#########################
#----EXECUTE SCRIPT2----#
#########################

cd $WD/coverage
ls *trimmed.fasta > filelist.txt
$GWD/scripts/samples2genes.py > outstats.csv
