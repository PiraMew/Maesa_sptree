
#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=exon_mapper
#SBATCH --time=01-00:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: exon_mapper_use.sh
# --- Action: execute exon_mapper.py
# --- Input: alignments in alignedseq directory
# --- Output: alignments plus 2 exons
# USAGE: sbatch exon_mapper_use.sh (*execute from global working directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 28/05/2021
##################################

#####################
#----DIRECTORIES----#
#####################

#working directories
GWD=$PWD #global working directory, with subprojects and scripts (`/faststorage/project/Maesa`, in my case)
WD=$GWD/steps #current working directory

#make a new directory for outputs
mkdir -p $WD/MAFFT/alignments_exon

#####################
#--EXECUTE SCRIPT---#
#####################

$GWD/scripts/exon_mapper.py
