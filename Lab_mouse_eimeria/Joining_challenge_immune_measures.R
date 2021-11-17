#load libraries
library(tidyr)
library(ggplot2)
library(dplyr)
library(stringr) #to manipulate strings

#read challenge infections
Challenge_Infections <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data_products/Challenge_infections.csv")
str(Challenge_Infections)
#show column names
colnames(Challenge_Infections)

#read facs tables 
#starting with p4 FACS
P4_FACS <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/P4_082020_Eim_FACS.csv")
P4_FACS$EH_ID <- str_replace_all(P4_FACS$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table
str(P4_FACS)
colnames(P4_FACS)

#read E57 FAcs
E57_FACS <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/E7_112018_Eim_FACS.csv")
E57_FACS$EH_ID <- str_replace_all(E57_FACS$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table
str(E57_FACS)
colnames(E57_FACS)


#read E11 FACS
E11_FACS <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/E11_012021_Eim_FACS.csv")
E11_FACS$EH_ID <- str_replace_all(E11_FACS$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table
str(E11_FACS)
colnames(E11_FACS)
