
#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=retrieveparalog
#SBATCH --time=00-01:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=4

##################################
# Project: Maesa Phylogeny
# script: paralog_retrieve.sh
# --- Action: retrieve paralogs
# --- Input: outputs from readsfirst.sh, namelist.txt & paralog_genelist.txt
# --- Output: *.paralogs.fasta in 'paralogs' directory & paralog_summary.txt
# USAGE: sbatch paralog_retrieve.sh (*execute from within hybpiper directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################


##need to make a paralog genelist file first

parallel "python /home/psumanon/HybPiper/paralog_retriever.py namelist.txt {} > {}.paralogs.fasta" ::: < ./paralog_genelist.txt 2> paralog_summary.txt

##MOVE paralogs.fasta to new directory

mkdir paralogs
mv *.paralogs.fasta ./paralogs
