#!/usr/bin/env python3

# this script filters paralog genes out of the analysis
# Author: Pirada Sumanon
# Date: 28/05/2021

import os
import shutil

# start at the global working directory
gwd = os.getcwd()

with open(gwd+"/steps/hybpiper/paralog_genelist.txt", "r") as f:
    paralog_list = [line.strip() for line in f]

# change to the directory where the alignments are
os.chdir(gwd+"/steps/alignments_for_editing")
cwd = os.getcwd()

# make a new directory to store paralog alignments
os.mkdir(gwd+"/steps/alignments_for_editing/paralogs")

# list only alignment files not directory
files = (file for file in os.listdir(cwd)
        if os.path.isfile(os.path.join(cwd, file)))

#detect paralog and move to subdirectory paralogs
for file in files:
    locus = file.split("_")[0]
    if locus in paralog_list:
        shutil.move(cwd+'/'+file, cwd+'/paralogs/'+file)
