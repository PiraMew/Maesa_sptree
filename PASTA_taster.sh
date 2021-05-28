#!/bin/bash

#SBATCH --account=Maesa
#SBATCH --job-name=optrimal1
#SBATCH --time=00-02:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=16

#######
# Part of optrimAl package
# Author: Shee, Zhi Qiang
# (https://github.com/keblat/bioinfo-utils/blob/master/docs/advice/scripts/optrimAl.txt)

while read cutoff_trim
do
        mkdir $cutoff_trim

        for alignment in *.fasta
        do
          trimal -in ${alignment} -out ${cutoff_trim}/${alignment/.fasta}_trimmed.aln -htmlout ${cutoff_trim}/${alignment/.fasta}.htm -gt $cutoff_trim

                # check if alignment was trimmed to extinction by trimAl

                if grep ' 0 bp' ${cutoff_trim}/${alignment}.aln
                then
                        rm -f ${cutoff_trim}/${alignment}.aln
                fi
        done

        cd ${cutoff_trim}
        python3 ~/miniconda3/bin/AMAS.py summary -f fasta -d dna -i *.aln

        mv summary.txt ../summary_${cutoff_trim}.txt
        
        cd ..

done < cutoff_trim.txt
