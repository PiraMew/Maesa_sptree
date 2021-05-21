#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=readsfirst
#SBATCH --time=07-00:00:00 #It may take longer time for a big dataset
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=16

##################################
# Project: Maesa Phylogeny
# script: readsfirst.sh
# --- Action: running readsfirst.py of HybPiper (mapping reads to the bait target file)
# --- Input: trimmed reads & target file
# --- Output: directories of each sample contains mapped reads
# USAGE: sbatch readsfirst.sh
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

#####################
#----DIRECTORIES----#
#####################

#working directories
GWD=$PWD #global working directory, with subprojects and scripts (in my case, it's /faststorage/project/Maesa)
WD=$GWD/steps #current working directory

#make new directories
mkdir -p $WD/hybpiper

#########################
#----CREATE NAMELIST----#
#########################

cd $WD/trimmed

for f in *_1_paired_trimmed.fastq; do (echo ${f/_1_paired_trimmed.fastq} >> namelist.txt); done

mv namelist.txt ../hybpiper

#########################
#---HYBPIPER:ASSEMBLY---#
#########################
cd $WD/hybpiper

while read name; 
do ~/HybPiper/reads_first.py -b ~/target/mega353.fasta -r $WD/trimmed/${name}_1_paired_trimmed.fastq $WD/trimmed/${name}_2_paired_trimmed.fastq --unpaired $WD/trimmed/${name}_unpaired12.fastq --prefix $name --bwa
done < namelist.txt

