#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=AMAS
#SBATCH --time=00-08:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: alignment_stats.sh
# --- Action: give statistic summary of alignments using AMAS
# --- Input: alignments and partition files used in tree building
# --- Output: summary text files
# USAGE: sbatch alignment_stat.sh (execute from GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk)
# Date: 05/07/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts
WD=$PWD/steps #current working directory

#make a new directory
mkdir -p $WD/stats

###################
#-----ACTIONS-----#
###################

cd $WD
#copy alignments and partition file to the directory
cp $WD/finaltree/done/*.fasta $WD/stats
cp $WD/finaltree/genetrees/*_part.txt $WD/stats

#prepare partition file
cd $WD/stats
for f in *_part.txt; do (sed -i'.old' -e $'s/DNA, //g' $f); done
rm *.old

#split exon and intron
for f in *.fasta; do (AMAS.py split -f fasta -d dna -i $f -l ${f/_clean_pruned_reduced.fasta}_part.txt -u fasta); done

#move exons and introns to different directories
mkdir exon intron
mv *_exon-out.fas exon
mv *_intron-out.fas intron

#supercontigs: concatenate and summarize
AMAS.py concat -i *.fasta -f fasta -d dna -c 1
mv concatenated.out concatenated.fasta
AMAS.py summary -f fasta -d dna -i *.fasta

#exons: concatenate and summarize
cd exon
AMAS.py concat -i *.fas -f fasta -d dna -c 1
mv concatenated.out concatenated_exon.fas
AMAS.py summary -f fasta -d dna -i *.fas
mv summary.txt summary_exon.txt
mv partitions.txt partitions_exon.txt

#introns: concatenate and summarize
cd ../intron
AMAS.py concat -i *.fas -f fasta -d dna -c 1
mv concatenated.out concatenated_intron.fas
AMAS.py summary -f fasta -d dna -i *.fas
mv summary.txt summary_intron.txt
mv partitions.txt partitions_intron.txt
