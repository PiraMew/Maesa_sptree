#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=RNR
#SBATCH --time=00-06:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=8

##################################
# Project: Maesa Phylogeny
# script: RNR.sh
# --- Action: perform RogueNaRok
# --- Input: a set of ML trees for each alignment
# --- Output: rogue pruned alignments
# USAGE: sbatch RNR.sh (execute in RNR directory)
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 08/06/2021
##################################

#detect rogues
for f in *.runtrees;
do 
    sed -i'.old' -e$'s/\[[^][]*\]//g' $f
    rm ${f}.old
    ~/RogueNaRok-master/RogueNaRok -i $f -s 2 -n ${f/_OGexonadded_aligned_clean.fasta.runtrees}_dropset2
    cat RogueNaRok_droppedRogues.${f/_OGexonadded_aligned_clean.fasta.runtrees}_dropset2 | cut -f 3 | tail -n +3 | tr "," "\n" > ${f/_OGexonadded_aligned_clean.fasta.runtrees}_rogues_dropset2.txt
done

#pruned rogues from the alignments
for i in *_rogues_dropset2.txt;
do
    if [ -s $i ]; 
    then 
    	seqkit grep -f $i -v ${i/_rogues_dropset2.txt}_OGexonadded_aligned_clean.fasta -o ${i/_rogues_dropset2.txt}_pruned.fasta
    else
        echo ${i/_rogues_dropset2.txt} "no rogue detected"
	    cp ${i/_rogues_dropset2.txt}_OGexonadded_aligned_clean.fasta ${i/_rogues_dropset2.txt}_pruned.fasta
    fi
done
