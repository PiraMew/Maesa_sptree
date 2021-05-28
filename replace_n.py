#!/usr/bin/env python3

#################
# This script creates a function to find a certain character and replace it with another character.
# In our case, we use it to replace 'n' in the alignments with gap(-).
#################

import os

#Go to the folder where all the files are
cwd = os.getcwd()
a = cwd.split("/")[:-1]
save_path = "/".join(a)+"/optrimal_ready"

#Make function
def replace(filename,textToFind,replaceTextWith):
    f = open(filename,'r') # Opens file
    my_list = [] # Makes list
    data = [line.strip() for line in f.readlines()] #Adds each line in file to list
    for line in data:
        if ">" in line:
            my_list.append(line) #If the line has ">" in it we just add it to our list
        else:
            temp = line.replace(textToFind,replaceTextWith) # If there is not ">" in the line do the replacement 
            my_list.append(temp)
    #Saving the results to a new file
        NewFileName = filename
        completeName = os.path.join(save_path, NewFileName)  
		
    with open(completeName, 'w') as f:
        for item in my_list:
            f.write("%s\n" % item)
        f.close()

#For each file in the folder we do the following

for filename in os.listdir(os.getcwd()):
  replace(filename,"n","-")
