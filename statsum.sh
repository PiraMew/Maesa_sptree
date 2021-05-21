#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=StatSum
#SBATCH --time=00-03:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: statsum.sh
# --- Action: statistic summary of HybPiper outputs
# --- Input: outputs from readsfirst.sh
# --- Output: seq_lengths.txt for producing a heatmap in R and stats.txt for summary
# USAGE: sbatch statsum.sh (*execute from within hybpiper directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
WD=$PWD/ #current working directory

####################
#---STAT SUMMARY---#
####################

mkdir output

python ~/HybPiper/get_seq_lengths.py ~/target/mega353.fasta namelist.txt dna > output/seq_lengths.txt

##the above command will result in seq_lengths.txt which will be use to produce a heatmap in R using gene_recovery_heatmap.R

##then to get a statistical summary: 
python ~/HybPiper/hybpiper_stats.py output/seq_lengths.txt namelist.txt > output/stats.txt
