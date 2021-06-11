# Maesa_sptree
all scripts using in building a species tree of *Maesa* (Primulaceae s.l.)
Pirada Sumanon, April 2021

## 0. Working directories
The analyses were performed mainly on GenomeDK cluster.
All programs/softwares used in the pipeline that cannot be installed by conda need to be installed at root (`~`)
All data are stored in a project folder `/faststorage/project/Maesa`
- data: directory for raw data with renamed files and also alignments after manual edited (this directory is backed up)
    - `raw`
    - `edited_alignments`
- scripts: all scripts used (this directory is backed up)
- steps: input and output in each step of the pipeline
    - `essential`: all txt files that needed in the analysis (e.g. outgroups.txt)
    - `input_rawreads`: raw reads copied from `../data`
    - `fastqc`: contains 2 subdirectories for the results for raw reads (`fastqc_raw`) and trimmed reads (`fastqc_trimmed`) (NOTE: I run fastqc on Linospadix & my own computer, so this directory is not exist on GenomeDK.)
    - `trimmed`: trimmed reads
    - `hybpiper`: all about hybpiper 
        *Target file needs to be at `~/target`
    - `coverage`: output of coverage trimming 
    - `seq_sets2`: sequence sets after coverage trimming and length filtering
    - `MAFFT`: all related to sequence alignments
    - `optrimal_prepare`: files before optrimal
    - `optrimal_ready`: files ready for optrimal and also outputs from optrimal
    - `alignments_for_editing`: trimmed alignments for manaul editing
    - `alignments_edited`: alignments after manual editing, plus a subdirectory `noempty` for alignments that remove empty sequences (_noempty.fasta) and also alignments without outgroup sequences (_noOG.fasta)
    - `addOGexons`: alignments which exon outgroups were added to. These OGexonadded alignments are ready for further analysis.
    - `iqtree_prepare`: clean alignments (no exon1 and exon2) and partition files, and a subdirectory containing a set of 10 MLtrees for each alignments for RogueNaRok.
    -  `RNR`: everything produced during RNR to detect and prune rogue taxa plus pruned alignments
    -  `prelim_iqtree`: first gene trees from IQ-Tree before Treeshrink
    -  `treeshrink`: for TreeShrink analysis
    -  `alignments_edited_2nd`: already checked for long branches and edited alignments for final tree building
    -  `finaltree`: final gene trees from IQ-tree and species tree  from ASTRAL


## 1. Quality Control and Read Trimming
Start at the Global Working Directory (main directory with subproject and scripts; in my case, it's `/faststorage/project/Maesa`)
Execute `QC_and_Trim.sh` for running fastqc on raw reads, trimming raw reads with trimmomatic and running fastqc on trimmed reads
- fastqc outputs stored in `fastqc`, inspect the .html outputs for read quality of each sample
- trimmomatic outputs (trimmed reads) stored in `trimmed`

## 2. HybPiper

### 2.1 Mapping reads to genes
by executing `readsfirst.sh` from Global Working Directory (`/faststorage/project/Maesa`, in my case)
### 2.2 Getting statistical summary 
run from within `hybpiper` directory by executing `statsum.sh` 
        this script uses get_seq_lengths.py and test_stats.py of HybPiper and will produce 2 output files
        - seq_lengths.txt for producing a heatmanp in R 
        - stats.txt for summary
### 2.3 Retrieving sequences for exons, introns and supercontigs 
by running `retrieve_seq.sh` from within `hybpiper` directory,
        For intronerate.py, I used intronerate_dev.py instead of the one from release version. (https://github.com/mossmatters/HybPiper/issues/41).
### 2.4 Extracting paralogs
Run `paralog_inv.sh`, then create paralog_genelist.txt and execute `paralog_retrieve.sh`

>To create a paralog genelist, use the file obtained from previous step/copy the output printed on screen while running `paralog_inv.sh`, remove all the information from it except for the gene name. 
>Example: '2 paralogs written for Gene001' changes to 'Gene001'. Then delete any duplicated lines. In some text editor, go to "Text->Process Duplicated Lines". One gene per line.

For more detail on paralogs: https://github.com/mossmatters/HybPiper/wiki/Paralogs


## 3. Coverage trimming and length filtering
*This part follows Wolf Eiserhardt's scripts for Dypsidinae_species_tree.*
In a global working directory, run `coverage_use.sh`
This script will execute `coverage.py` then `samples2genes.py`.
Output: the new gene fasta files with coverage trimming will be saved in `seq_sets2` and ready for alignment.

## 4. Alignment
### 4.1 Sequence alignment using MAFFT
From GWD, run `MAFFT.sh`.
The aligned sequences will be stored in `MAFFT/alignedseq`.

### 4.2 Mapping exons to alignments
This step creates new alignments that contain the original alignments plus the exon sequences of the two species that had the highest recovery success at each locus. Using `exon_mapper.py` written by Wolf Eiserhardt.
The outputs will be stored in `MAFFT/alignments_exon`.

## 5. Gap trimming
### 5.1 preparation
- prepare alignments by executing `optrimal_prepare.sh`, the alignments ready for optrimal will be stored in `optrimal_ready`.
- In `optrimal_ready`, generate `cutoff_trim.txt` with desired `-gt` values to be tested (one value per line, the values must included 0 and 1). For example:
```
0
0.2
0.3
0.4
0.5
0.6
0.7
1
```
### 5.2 optrimAL
run `optrimal_run.sh` from GWD.
This script implemented PASTA_taster.sh and optrimAL.R written by Shee, Zhi Qiang (https://github.com/keblat/bioinfo-utils/blob/master/docs/advice/scripts/optrimAl.txt).

*Note: optrimAL.R was modified at the last line to NOT discard alignments with data loss exceeding 30%.*

The last part of the script will copy the trimmed alignments to `alignments_for_editing`. Then, it will filter paralog loci out and move them to `paralogs` subdirectory.

*Note: some alignments may contain empty sequences, but we will deal with this issue after finish manual editing.*

## 6. Manual editing
Each alignment needs to cleaned manually in an alignment editor program (i.e. AliView).
- copy the directory `alignments_for_editing` to a place of your choice
- after making all neccessary edits, save the edited version of all alignments to `alignments_edited`
- *If alignments are found to be overall wrong or doubtful (e.g. paralogs/chimeric sequences), move these alignments to `alignments_bad` and excluded from further analysis.*
    
## 7. Tree building

### 7.1 Preparation
From GWD, run `iqtree_prepare.sh`. This script will perform as followed:
- remove empty sequences from alignments using `remove_empty.py`
- remove outgroup sequences and add outgroup exons instead. *outgroup sequences used in our analysis (Ardisia) look weird for intron regions, so we decided to remove outgroup sequences and added only outgroup exons for the analysis.* To do that, the script use `removeOG.py`and `addOGexon.py`
- generate partition files and remove exon sequences (exon1 and exon2) from the alignments using `partition_v2.py`

### 7.2 Detection of Rogue Taxa
Based on low branch supports in our preliminary tree, we thought that it was severly affected from rogue taxa. Thus, we decided to implemented RogueNaRok algorithm (https://github.com/aberer/RogueNaRok) to detect and prune those taxa out. To do that, we have to:
- generate a set of ML trees: we go for 10 trees using `10MLtrees.sh` executed within `iqtree_prepare` directory the files that ready for RNR will be store in `RNR` directory
- In `RNR`, run `RNR.sh` which produces rogue-pruned alignments

### 7.3 Add outgroups back to the pruned alignments
RNR may remove outgroup sequences in some alignments, we need to add them back by running `postRNR.sh`.

### 7.4 Preliminary run IQ-Tree
run `firstiqtree.sh` to get gene trees.

### 7.5 TreeShrink
from GWD, execute `treeshrink_prep.sh` followed by `treeshrink.sh`, this will print a report of long branches detected by TreeShrink in `report.txt` in `treeshrink` directory. Use it to check the alignments in 2nd manual editing.

### 7.6 Manual editing alignments: 2nd round
A quick check of the alignments (now stored in `steps/prelim_iqtree/done` in AliView based on the result from TreeShrink, remove/edit sequences either appropriate. May use gene trees generated from 7.4 as a guideline. The edited alignments from this step should be stored in `alignments_edited_2nd`


## 8. Final Tree Building

### 8.1 IQ-Tree for gene trees
execute `final_iqtree.sh` from GWD, this script will
   - remove some problematic samples and repetitive samples (*IMPORTANT:* prepare a list of samples in blacklists.txt, same line seperated by space)
```
#example format of blacklists.txt

sample1 sample99 sample124
```
   - copy input files to `finaltree` directory for working
   - perform IQ-tree

### 8.2 ASTRAL for species tree

run `speciestree.sh` which check outgroups, root gene trees, collapse low support branches, build species tree and annotate tree.
I set to collapse branch that has BS<=10 and <30, so will get 2 sets of outputs. Choose the one that has higher resolution.


Then for fullannotation files (genetrees_bs30_astralfull_annot.tre or genetrees_bs10_astralfull_annot.tre), open it in TextEditor and

Replace:

[q1=[\d,.,E,-]+;q2=[\d,.,E,-]+;q3=[\d,.,E,-]+;f1=[\d,.,E,-]+;f2=[\d,.,E,-]+;f3=[\d,.,E,-]+;pp1=[\d,.,E,-]+;pp2=[\d,.,E,-]+;pp3=[\d,.,E,-]+;QC=[\d,.,E,-]+;EN=([\d,.,E,-]+)]

With:

\1

And at some branches, there might be NaN, 
So replace:

[q1=[\w+]+;q2=[\w+]+;q3=[\w+]+;f1=[\d,.,E,-]+;f2=[\d,.,E,-]+;f3=[\d,.,E,-]+;pp1=[\d,.,E,-]+;pp2=[\d,.,E,-]+;pp3=[\d,.,E,-]+;QC=[\d,.,E,-]+;EN=([\d,.,E,-]+)]

With:
\1

save the file as "genetrees_bs30_astral_EN.tre" or "genetrees_bs10_astral_EN.tre"


## 9. Tree Visualization
