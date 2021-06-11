#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=speciestree
#SBATCH --time=03-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: speciestree.sh
# --- Action: root, collapse low support branches and generate species trees
# --- Input: gene trees
# --- Output: species trees from ASTRAL
# USAGE: sbatch speciestree.sh (execute in GWD directory)
# NOTE: provide a string of outgroups in ROOT&COLLAPSE section before running the script!!!
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 11/06/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts
WD=$PWD/steps #current working directory


#######################
#---CHECK OUTGROUPS---#
#######################
cd $WD
python $GWD/scripts/check_outgroups.py


#######################
#---ROOT & COLLAPSE---#
#######################
cd $WD/finaltree/genetrees
mkdir ../speciestree

#*****change the variable content to suit your outgroups*****
outgroups="194KEW_Ardisiacelebica,195KEW_Ardisialanceolata,196KEW_Ardisiaoocarpa,197KEW_Ardisiaamabilis,198KEW_Ardisiacopelandii,199KEW_Ardisiadiversilimba,200KEW_Ardisiasumatrana,201KEW_Ardisiaelmeri,203KEW_Ardisiasteirantha,205KEW_Ardisiatinifolia,206KEW_Ardisiaguianensis"

for f in *.tre
do
    ~/phyx/src/pxrr -t $f -g $outgroups -s -o ${f/.tre}_rooted.tre
    ~/newick-utils-1.6/src/nw_ed ${f/.tre}_rooted.tre 'i & (b<30)' o >> ../speciestree/genetrees_bs30.tre
    ~/newick-utils-1.6/src/nw_ed ${f/.tre}_rooted.tre 'i & (b<=10)' o >> ../speciestree/genetrees_bs10.tre
done

#######################
#-------ASTRAL--------#
#######################
cd ../speciestree

for f in *.tre;
do (java -jar ~/Astral/astral.5.7.5.jar -i $f -o ${f/.tre}_astral.tre 2> ${f/.tre}_astral.log);
done

#to get full annotation
for f in *_astral.tre;
do (java -jar ~/Astral/astral.5.7.5.jar -q $f -i ${f/_astral.tre}.tre -o ${f/.tre}full_annot.tre -t 2 2> ${f/.tre}_annotation.log);
done
