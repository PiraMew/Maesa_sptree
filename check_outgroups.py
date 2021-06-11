#!/usr/bin/env python3
 
#this script is for checking if any treefile contains no outgroup
#those treefiles will be print in no_outgroup.txt

import os, dendropy, re
import shutil
import glob

#Directory variables
cwd = os.getcwd() #must be GWD/steps
essential_dir = cwd+"/essential"


with open(essential_dir+"/outgroups.txt", "r") as f:
    outgroups = [line.strip() for line in f]

os.chdir("finaltree/genetrees")
trees_dir = os.getcwd()

filelist= [file for file in os.listdir() if file.endswith('.tre')] #create a list contain all tree file in the directory
no_outgroup = [] #create a blank list for no_outgroup tree file

for treefile in filelist:
    tree = dendropy.Tree.get(path=treefile, schema="newick")   
    tips = str(tree.taxon_namespace)
    a = tips.replace(" ", "_") #dendropy make _ to space, so we need _ back in order to match outgroup names
    tipnames = a.replace(",_", ", ") #remove unnecessary _ from previous replacement
    check = any(item in tipnames for item in outgroups)
    if check is True:
        print(treefile , 'OK')
    else:
        print(treefilose , 'Outgroup not in a tree')
        no_outgroup.append(treefile.split(".")[0])
        
#to create a txt file contain treefiles with no outgroups.
with open("no_outgroup.txt", "w") as x:
    for item in no_outgroup:
        x.write(item + '\n')
    x.close()


for i in no_outgroup:
    for fn in glob.glob(f"{trees_dir}/{i}*'):
        toPath = trees_dir+"/no_outgroup/" + fn.split("/")[-1]
        shutil.move(fn, toPath)
