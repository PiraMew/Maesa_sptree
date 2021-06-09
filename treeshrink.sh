#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=treeshrink
#SBATCH --time=00-08:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: treeshrink.sh
# --- Action: perform treeshrink
# --- Input: gene trees in treeshrink folder
# --- Output: report of long branches (report.txt)
# USAGE: sbatch treeshrink.sh (from GWD)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 09/06/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts (in my case, it's /faststorage/project/Maesa)
WD=$PWD/steps #current working directory

###################
#---TREESHRINK----#
###################
cd $WD/treeshrink

run_treeshrink.py -i . -t input.tre -x $WD/essential/outgroups.txt -m per-gene

#create a report of long branches detected
touch report.txt
for i in */output.txt;
do
    if [ -s $i ]; then
      echo ${i/output.txt} >> report.txt
      cat */output.txt >> report.txt
      echo $'\n' >> report.txt
    fi
done

