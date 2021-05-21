#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=QC&Trim
#SBATCH --time=00-06:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=4

##################################
# Project: Maesa Phylogeny
# script: QC_and_Trim.sh
# --- Action: QC & Trim reads with FastQC & Trimmomatic
# --- Input: untrimmed reads
# --- Output: trimmed reads and fastqc files
# USAGE: sbatch QC_and_Trim.sh
# Author: Pirada Sumanon (pirada.sumanon@bio.au.dk) 
# Date: 21/05/2021
##################################

###################
#---DIRECTORIES---#
###################

#working directories
GWD=$PWD #global working directory (main directory) with subproject and scripts (in my case, it's /faststorage/project/Maesa)
WD=$PWD/steps #current working directory

#make new directories
mkdir -p $WD/input_rawreads
mkdir -p $WD/fastqc
mkdir -p $WD/trimmed
mkdir -p $WD/fastqc/fastqc_raw
mkdir -p $WD/fastqc/fastqc_trimmed

#copy reads to input_rawreads
cp $GWD/data/raw/*.fq.gz $WD/input_rawreads

###################
#--FASTQC BEFORE--#
###################
cd $WD/input_rawreads

for f in *.fq.gz;
do fastqc $f --outdir $WD/fastqc/fastqc_raw;
done

rm $WD/fastqc/fastqc_raw/*.zip #remove unnecessary zip files

##check .html fastqc outputs

###################
#---TRIMMOMATIC---#
###################

for i in *_1.fq.gz; 
do (java -jar $GWD/programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 -phred33 $i ${i/_1.fq.gz}_2.fq.gz $WD/trimmed/${i/_1.fq.gz}_1_paired_trimmed.fastq $WD/trimmed/${i/_1.fq.gz}_1_unpaired.fastq $WD/trimmed/${i/_1.fq.gz}_2_paired_trimmed.fastq $WD/trimmed/${i/_1.fq.gz}_2_unpaired.fastq ILLUMINACLIP:$GWD/programs/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10:1:true LEADING:3 TRAILING:3 MAXINFO:40:0.5 MINLEN:36); 
done

#change working directory to trimmed
cd $WD/trimmed

#combined unpaired reads to one file (HybPiper needs only one unpaired file)
#name cat file as *_unpaired12.fastq in order to easily removed each *unpaired.fastq afterwards

for i in *_1_unpaired.fastq;
do (cat $i ${i/_1_unpaired.fastq}_2_unpaired.fastq > ${i/_1_unpaired.fastq}_unpaired12.fastq);
done

#remove each unpaired read
rm *_unpaired.fastq

####################
#---FASTQC AFTER---#
####################

cd $WD/trimmed

for f in *.fastq;
do fastqc $f --outdir $WD/fastqc/fastqc_trimmed;
done

rm $WD/fastqc/fastqc_trimmed/*.zip #remove unnecessary zip files

##check .html fastqc outputs

cd $WD
