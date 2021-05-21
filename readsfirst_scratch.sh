#!/bin/bash
#SBATCH --account=Maesa
#SBATCH --job-name=readfirst
#SBATCH --time=07-00:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=24

# Create a temporary directory for the job in local storage
TMPDIR=/scratch/$SLURM_JOBID
export TMPDIR
mkdir -p $TMPDIR
cd $TMPDIR

# Copy the application binary if necessary to local storage
#cp -r /home/psumanon/HybPiper .

# Copy target file to local storage
#cp /home/psumanon/target/mega353.fasta .

# Copy input file(s) to local storage if necessary
cp /faststorage/project/Maesa/steps/trimmed/Ardisia/Ardisia/*.fastq .

##recheck the path to input files, target files and read_first.py
##Do NOT forget to create the namelist.txt before running

#create namelist first
for f in *_1_paired_trimmed.fastq; do (echo ${f/_1_paired_trimmed.fastq} >> namelist.txt); done

#run reads_first.py
while read name; 
do /home/psumanon/HybPiper/reads_first.py -b /home/psumanon/target/mega353.fasta -r ${name}_1_paired_trimmed.fastq ${name}_2_paired_trimmed.fastq --unpaired ${name}_unpaired12.fastq --prefix $name --bwa
done < namelist.txt



# Move the result files, logs, and any relevant data back to user's home directory. 
mkdir -p $SLURM_SUBMIT_DIR/$SLURM_JOBID
cp -r * $SLURM_SUBMIT_DIR/$SLURM_JOBID/

# Delete local storage on the way out as a clean up
cd $SLURM_SUBMIT_DIR
rm -rf /scratch/$SLURM_JOBID
