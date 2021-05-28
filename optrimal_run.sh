#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=optrimal
#SBATCH --time=00-02:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=16

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

cd $WD

###################
#----OPTRIMAL-----#
###################

$GWD/scripts/PASTA_taster.sh
Rscript --vanilla $GWD/scripts/optrimAL.R

