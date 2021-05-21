#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=paralog_investigate
#SBATCH --time=00-03:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=4

##################################
# Project: Maesa Phylogeny
# script: paralog_inv.sh
# --- Action: detecting paralogs
# --- Input: HybPiper outputs
# --- Output: print paralogs detected for each gene in paralog_genelist.txt
# USAGE: sbatch paralog_inv.sh (*execute from within hybpiper directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

##DETECTING PARALOGS

while read name;
do
echo $name
python ~/HybPiper/paralog_investigator.py $name 2> paralog_genelist.txt
done < namelist.txt
