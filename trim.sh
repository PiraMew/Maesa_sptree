#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=Trimmomatic
#SBATCH --time=00-06:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --ntasks=1 --cpus-per-task=1 --ntasks-per-node=1

# Execute your command
for i in *_1.fq.gz; 
do (java -jar /home/psumanon/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 -phred33 $i ${i/_1.fq.gz}_2.fq.gz /faststorage/project/Maesa/steps/trimmed/20210114/${i/_1.fq.gz}_1_paired_trimmed.fastq /faststorage/project/Maesa/steps/trimmed/20210114/${i/_1.fq.gz}_1_unpaired.fastq /faststorage/project/Maesa/steps/trimmed/20210114/${i/_1.fq.gz}_2_paired_trimmed.fastq /faststorage/project/Maesa/steps/trimmed/20210114/${i/_1.fq.gz}_2_unpaired.fastq ILLUMINACLIP:/home/psumanon/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10:1:true LEADING:3 TRAILING:3 MAXINFO:40:0.5 MINLEN:36); 
done
