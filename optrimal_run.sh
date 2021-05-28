#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=optrimal
#SBATCH --time=01-00:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: optrimal_run.sh
# --- Action: run optrimal to trim alignments
# -----------operate with 2 scripts, PASTA_taster.sh & optrimAL.R
# --- Input: untrimmed alignments
# --- Output: trimmed alignments
# USAGE: sbatch optrimal_run.sh (execute from GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 28/05/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory of the project)
WD=$PWD/steps/optrimal_ready #current working directory

#make new directory for copying outputs for next step
mkdir -p $GWD/steps/alignments_for_editing


###################
#----OPTRIMAL-----#
###################
cd $WD
$GWD/scripts/PASTA_taster.sh
Rscript --vanilla $GWD/scripts/optrimAL.R

######################################
#---Copy outputs for next process----#
######################################
cp *_trimmed.aln $GWD/steps/alignments_for_editing


############################################
#---Filter paralogs out of the analysis----#
############################################
cd $GWD
python $GWD/scripts/paralog_filter.py


